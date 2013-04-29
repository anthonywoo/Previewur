class ImagesController < ApplicationController

  def index
    @images = Image.all
  end

  def new
    @image = Image.new
    #@comment = Comment.new
  end

  def show
    @image = Image.includes(:comments).find_by_slug(params[:slug])
    @comment = Comment.new

  end

  def create
    binding.pry
    #Tag.where({:name => ["trailer", "wtf"]})
    @image = Image.new(params[:image])
    binding.pry
    @image.set_tags = params[:tag_names]
    @image.update_file_name_attributes if @image.source.path #TODO FIX!
    respond_to do |format|
      if @image.save
        format.html { redirect_to images_url, :notice => 'Article was successfully created.' }
      else
        format.html { render :new }
        format.js
      end
    end
  end


end
