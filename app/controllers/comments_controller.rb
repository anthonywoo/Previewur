class CommentsController < ApplicationController

  def create
    @comment = Comment.new(params[:comment])
    respond_to do |format|
      if @comment.save
        @comment = Comment.new
        @image = Image.includes(:comments).find_by_id(params[:comment][:image_id])
        format.js
      else
        format.js
      end
    end
  end

end
