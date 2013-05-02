class CommentVotesController < ApplicationController

  def create
    comment = Comment.find(params[:comment_id])
    @image = comment.image
    unless current_user.voted?(comment)
      if params[:vote_type] == "upvote"
        current_user.up_vote(comment)
      else
        current_user.down_vote(comment)
      end
    end
    respond_to :js
  end

end
