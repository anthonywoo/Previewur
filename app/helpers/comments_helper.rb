module CommentsHelper

  def check_if_upvoted(comment)
    return unless current_user
    if current_user.voted?(comment)
      current_user.up_voted?(comment) ? "upvoted-comment" : "nonvote-comment"
    else
      "comment-vote"
    end
  end

  def check_if_downvoted(comment)
    return unless current_user
    if current_user.voted?(comment)
      current_user.down_voted?(comment) ? "downvoted-comment" : "nonvote-comment"
    else
      "comment-vote"
    end
  end


end
