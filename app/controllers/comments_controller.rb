class CommentsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create]
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        @image = Image.includes(:comments).find_by_id(params[:comment][:image_id])
        @comment = Comment.new
        format.js
      else
        @image = Image.includes(:comments).find_by_id(params[:comment][:image_id])
        format.js
      end
    end
  end

end
