class ImagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create]
  
  def index
    @images = params[:search] ? Image.fetch_images(params[:search]) : Image.all
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @image = Image.new
  end

  def show
    @image = Image.find_by_slug(params[:slug])
    @comment = Comment.new
    @related_images_by_tag = @image.fetch_related_images(10)
  end

  def create
    @image = Image.new(params[:image])
    @image.set_tags = params[:tag_names] if params[:tag_names]

    if @image.save
      respond_to do |format|
        format.html { redirect_to images_url, :notice => 'Submission complete. We will email you when the image is ready.'}
      end
    else
      respond_to do |format|
        format.html {flash[:error] = "Your uploaded source had an invalid content_type."; redirect_to images_url}
        format.js
      end
    end
  end

  def random
    offset = rand(Image.count)
    random_image = Image.first(:offset => offset)
    redirect_to image_url(random_image)
  end

end
