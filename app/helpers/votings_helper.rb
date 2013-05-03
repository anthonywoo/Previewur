module VotingsHelper

  def check_image_upvote
    return "nonvote-comment" unless current_user
    if current_user.voted?(@image)
      current_user.up_voted?(@image) ? "upvoted-comment" : "nonvote-comment"
    else
      "vote"
    end
  end

  def check_image_downvote
    return "nonvote-comment" unless current_user
    if current_user.voted?(@image)
      current_user.down_voted?(@image) ? "downvoted-comment" : "nonvote-comment"
    else
      "vote"
    end
  end

end
