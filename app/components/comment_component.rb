# frozen_string_literal: true

class CommentComponent < ViewComponent::Base
  def initialize(comment:, current_user:)
    return if comment.nil?

    @current_user = current_user
    @comment = comment
    @last_update = last_update
    @current_owner = can_edit_or_delete?
  end

  private

  def last_update
    return if @comment.nil?

    user_name = @current_user == @comment.user ? 'You' : @comment.user.name
    action = @comment.parent ? 'replied' : 'commented'

    "#{user_name} #{action} #{time_ago_in_words(@comment.created_at)} ago ."
  end

  def can_edit_or_delete?
    return true if @comment.user == @current_user
    return true if @comment.post.group.user == @current_user

    false
  end
end
