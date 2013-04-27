class Image < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :source, :preview
  has_attached_file :source, :url  => "/system/:attachment/:id/:filename",
     :path => ":rails_root/public/system/:attachment/:id/:filename"

  has_attached_file :preview, :url => "/system/:attachment/:id/:filename",
     :path => ":rails_root/public/system/:attachment/:id/:filename"

  validates :title, :source, :presence => true
  validates_attachment_size :source, :in => 0.megabytes..5.megabytes

  after_create :generate_preview, :generate_gif


  def source_path
    self.source.path
  end

  def generate_preview

    #path = ":/rails_root/public/system/sources/#{self.id}/#{self.source_file_name}"
    # binding.pry
    # movie = FFMPEG::Movie.new(source_path)
    # ffmpeg -i charlie.mp4 -t 8 -r 8 out%03d.gif #80 frames, 3.8mb, decent qual
    # gifsicle --delay=12 --optimize=3 --loop *.gif > anim.gif
    # self.source.path
    #mpeg to create folder of pngs
    #imagemagick to generate the gif
    #convert out001.gif -trim -resize 150x150 -gravity center -background black -extent 150x150 test.gif
    binding.pry
  end

  def generate_gif

  end
  
end
