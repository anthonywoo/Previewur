class ImagesController < ApplicationController

  def index
    @images = Image.all
  end

  def new
    @image = Image.new
  end

  def show
    @image = Image.find(params[:id])
  end

  def create
    @image = Image.new(params[:image])
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
