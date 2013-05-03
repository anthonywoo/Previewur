module CommentsHelper

  def check_if_upvoted(comment)
    return "nonvote-comment" unless current_user
    if current_user.comment_votings.map(&:voteable_id).include?(comment.id)
      current_user.comment_upvotings.map(&:voteable_id).include?(comment.id) ? "upvoted-comment" : "nonvote-comment"
    else
      "comment-vote"
    end
  end

  def check_if_downvoted(comment)
    return "nonvote-comment" unless current_user
    if current_user.comment_votings.map(&:voteable_id).include?(comment.id)
      current_user.comment_downvotings.map(&:voteable_id).include?(comment.id) ? "downvoted-comment" : "nonvote-comment"
    else
      "comment-vote"
    end
  end


end
