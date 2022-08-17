# frozen_string_literal: true

module CommentsHelper
  def comment_last_update(comment)
    return if comment.nil?

    user_name = current_user == comment.user ? 'You' : comment.user.name
    action = comment.parent ? 'replied' : 'commented'

    "#{user_name} #{action} #{time_ago_in_words(comment.created_at)} ago ."
  end
end
