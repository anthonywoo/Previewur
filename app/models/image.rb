class Image < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :order => 'created_at DESC'
  attr_accessible :title, :source, :preview
  has_attached_file :source, :url  => "/system/images/:id/:filename",
     :path => ":rails_root/public/system/images/:id/:filename"

  has_attached_file :anim_gif, :url => "/system/images/:id/:filename",
     :path => ":rails_root/public/system/images/:id/:filename"

  has_attached_file :preview, :url => "/system/images/:id/:filename",
     :path => ":rails_root/public/system/images/:id/:filename"


  validates :title, :slug, :presence => true
  validates_attachment :source, :presence => true,
  :size => { :in => 0..5.megabytes }
  #validates :source, :attachment_presence => true
  #validates_attachment_size :source, :in => 0.megabytes..5.megabytes
  before_validation :generate_slug
  after_commit :generate_gif, :on => :create

  def update_file_name_attributes
    self.anim_gif_file_name = "animated.gif"
    self.preview_file_name = "preview.gif"
  end

  def to_param
    self.slug
  end

  def source_path
    self.source.path
  end

  private 

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


    #path = ":/rails_root/public/system/sources/#{self.id}/#{self.source_file_name}"
    # binding.pry
    # movie = FFMPEG::Movie.new(source_path)
    # ffmpeg -i charlie.mp4 -t 8 -r 8 out%03d.gif #80 frames, 3.8mb, decent qual
    # gifsicle --delay=12 --optimize=3 --loop *.gif > anim.gif
    # self.source.path
    #mpeg to create folder of pngs
    #imagemagick to generate the gif
    #convert out001.gif -trim -resize 150x150 -gravity center -background black -extent 150x150 test.gif
    generate_preview
  end

  def generate_preview
    #system("convert #{source_dir}/out001.gif -trim -resize 150x150 -gravity center -background black -extent 150x150 #{source_dir}/preview.gif")
    system("convert #{source_dir}/out001.gif -resize '160x160^' -gravity center -crop 160x160+0+0 +repage #{source_dir}/preview.gif")
    target_files_to_delete = "#{source_dir}/out*.*gif"
    system("rm #{target_files_to_delete}")
  end
  
end
