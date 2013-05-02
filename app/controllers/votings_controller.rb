class VotingsController < ApplicationController

  def create
    @image = Image.find(params[:image_id])
    # binding.pry
    if params[:vote_type] == "upvote"
      current_user.up_vote(@image)
    else
      current_user.down_vote(@image)
    end
    respond_to :js
  end
end
