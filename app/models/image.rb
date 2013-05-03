class Image < ActiveRecord::Base
  attr_accessible :title, :source, :preview, :tag_ids

  belongs_to :user
  has_many :comments, :order => 'created_at DESC'
  has_many :image_tags
  has_many :tags, :through => :image_tags

  make_voteable

  has_attached_file :source, :url  => "/system/images/:id/:filename",
     :path => ":rails_root/public/system/images/:id/:filename"

  has_attached_file :anim_gif, :url => "/system/images/:id/:filename",
     :path => ":rails_root/public/system/images/:id/:filename"

  has_attached_file :preview, :url => "/system/images/:id/:filename",
     :path => ":rails_root/public/system/images/:id/:filename"

  scope :days_created_ago, lambda{|day| where("created_at > ?", day.days.ago)}

  validates :title, :slug, :user, :presence => true
  
  validates_attachment :source, :presence => true,
                                :size => { :in => 0..5.megabytes },
                                :content_type => { :content_type => ["video/mp4", "video/x-flv", "video/quicktime"] }

  before_validation :generate_slug
  after_commit :post_conversion_actions, :on => :create

  def self.fetch_images(query)
    cat = query[:cat].to_sym
    time = query[:time].to_i
    Image.includes(:comments).days_created_ago(time).all.sort_by(&cat).reverse
  end

  def self.per_page(params)
    self.paginate(:page => params[:page], :per_page => 16)
  end

  def comment_count
    self.comments.length
  end

  def fetch_related_images(count)
    related_tags = tags.includes(:images)
    related_images = related_tags.map(&:images).flatten.uniq
    related_images.delete(self)
    related_images.shuffle.first(count)
  end

  def set_tags=(tags)
    availableTags = Tag.where({:name => tags})
    all_tags = availableTags
    to_be_created_tags = tags - availableTags.map(&:name)
    to_be_created_tags.each do |tag_name|
      all_tags << Tag.create(name: tag_name)
    end
    self.tags = all_tags
  end

  def to_param
    self.slug
  end

  def source_path
    self.source.path
  end

  def post_conversion_actions
    # self.delay.generate_gif_and_preview
    self.delay.generate_better_gif
  end

  def update_file_name_attributes
    self.anim_gif_file_name = "animated.gif"
    self.preview_file_name = "preview.gif"
    self.save!
  end

  def generate_better_gif
    system("ffmpeg -i #{source_path} -t 5 -r 5 -vcodec png #{source_dir}/out%03d.png")
    sleep 1
    system("convert -delay 12 -loop 0 #{source_dir}/*.png #{source_dir}/animated.gif")
    sleep 3
    system("convert #{source_dir}/out001.png -resize '160x160^' -gravity center -crop 160x160+0+0 +repage #{source_dir}/preview.gif")
    target_files_to_delete = "#{source_dir}/out*.*png"
    system("rm #{target_files_to_delete}")
    self.update_file_name_attributes
    sleep 2
    ImageMailer.image_ready_email(self).deliver
  end

  def generate_gif_and_preview
    self.generate_gif
    self.generate_preview
    self.update_file_name_attributes
  end

  def generate_slug
    self.slug ||= SecureRandom.urlsafe_base64(4)
  end

  def source_dir
    File.dirname(source_path)
  end

  def generate_gif
    system("ffmpeg -i #{source_path} -t 5 -r 8 #{source_dir}/out%03d.gif")
    sleep 1
    system("gifsicle --delay=12 --optimize=3 --loop #{source_dir}/*.gif > #{source_dir}/animated.gif")
  end

  def generate_preview
    system("convert #{source_dir}/out001.gif -resize '160x160^' -gravity center -crop 160x160+0+0 +repage #{source_dir}/preview.gif")
    target_files_to_delete = "#{source_dir}/out*.*gif"
    system("rm #{target_files_to_delete}")
  end
  
end
