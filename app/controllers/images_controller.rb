class ImagesController < ApplicationController

  def new
    @image = Image.new
  end

  def show
    @image = Image.find(params[:id])
  end

  def create
    @image = Image.new(params[:image])
    if @image.save
      redirect_to new_user_session_url
    else
      render :new
    end
  end
end
