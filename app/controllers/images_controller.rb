class ImagesController < ApplicationController

  def index
    @images = Image.all
  end

  def new
    @image = Image.new
    #@comment = Comment.new
  end

  def show
    @image = Image.find_by_slug(params[:slug])
    @comment = Comment.new
    @related_images_by_tag = @image.fetch_related_images(10)
  end

  def create
    @image = Image.new(params[:image])
    @image.set_tags = params[:tag_names] if params[:tag_names]
    respond_to do |format|
      if @image.save
        format.html { redirect_to images_url, :notice => 'Article was successfully created.' }
      else
        format.js
      end
    end
  end


end
