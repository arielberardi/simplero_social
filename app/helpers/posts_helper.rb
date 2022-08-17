# frozen_string_literal: true

module PostsHelper
  def post_last_update(post)
    return if post.nil?
    return if post.comments.empty?

    "Last comment #{time_ago_in_words(post.comments.last.created_at)} ago ."
  end
end
