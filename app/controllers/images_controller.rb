class ImagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create]
  
  def index
    @images = params[:search] ? Image.per_page(params).fetch_images(params[:search]) : Image.per_page(params)
    @latest_comments = Comment.includes(:image).limit(5).order("id DESC")

    return render :partial => "pagination.js.erb" if params[:pagination]

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
    @comments = @image.comments.includes(:votings)
    @comment = Comment.new
    @related_images_by_tag = @image.fetch_related_images(6)
  end

  def create
    @image = Image.new(params[:image])
    @image.set_tags = params[:tag_names] if params[:tag_names]
    @image.user = current_user
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

  def current_user
    @current_user ||= super && User.includes([:comment_upvotings, :comment_downvotings, :comment_votings]).find(@current_user.id)
  end

end
