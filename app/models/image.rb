class Image < ActiveRecord::Base
  attr_accessible :title, :source, :preview, :tag_ids

  belongs_to :user
  has_many :comments, :order => 'created_at DESC'
  has_many :image_tags
  has_many :tags, :through => :image_tags

  has_attached_file :source, :url  => "/system/images/:id/:filename",
     :path => ":rails_root/public/system/images/:id/:filename"

  has_attached_file :anim_gif, :url => "/system/images/:id/:filename",
     :path => ":rails_root/public/system/images/:id/:filename"

  has_attached_file :preview, :url => "/system/images/:id/:filename",
     :path => ":rails_root/public/system/images/:id/:filename"

  make_voteable
  validates :title, :slug, :presence => true
  validates_attachment :source, :presence => true,
  :size => { :in => 0..5.megabytes }
  #validates :source, :attachment_presence => true
  #validates_attachment_size :source, :in => 0.megabytes..5.megabytes
  before_validation :generate_slug
  after_commit :post_conversion_actions, :on => :create

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
    self.delay.generate_gif_and_preview
  end

  def update_file_name_attributes
    self.anim_gif_file_name = "animated.gif"
    self.preview_file_name = "preview.gif"
    self.save!
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
    system("ffmpeg -i #{source_path} -t 8 -r 8 #{source_dir}/out%03d.gif")
    sleep 1
    system("gifsicle --delay=12 --optimize=3 --loop #{source_dir}/*.gif > #{source_dir}/animated.gif")
  end

  def generate_preview
    system("convert #{source_dir}/out001.gif -resize '160x160^' -gravity center -crop 160x160+0+0 +repage #{source_dir}/preview.gif")
    target_files_to_delete = "#{source_dir}/out*.*gif"
    system("rm #{target_files_to_delete}")
  end
  
end
