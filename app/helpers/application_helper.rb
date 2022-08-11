# frozen_string_literal: true

module ApplicationHelper
  def time_from_last_update(comment)
    return nil if comment.nil?

    if comment.updated_at - comment.created_at < 1
      "Commented #{time_ago_in_words(comment.created_at)} ago"
    else
      "Updated #{time_ago_in_words(comment.updated_at)} ago"
    end
  end

  def time_from_last_comment(post)
    return nil if post.nil?

    if post.updated_at - post.created_at < 1
      "Commented #{time_ago_in_words(post.created_at)} ago"
    else
      "Updated #{time_ago_in_words(post.updated_at)} ago"
    end
  end

  def form_submit_name(action_name)
    action_name == 'edit' ? 'Save' : 'Create'
  end

  def form_title_name(action_name)
    action_name == 'edit' ? 'Edit' : 'Create'
  end

  def can_edit_or_delete?(object)
    current_owner?(object) || current_group_admin?(object)
  end

  def current_owner?(object)
    object.user == current_user
  end

  def current_group_admin?(object)
    return true if object.is_a?(Comment) && object.post.group.user == current_user
    return true if object.is_a?(Post) && object.group.user == current_user

    false
  end

  def user_joined?(group)
    group.users.include?(current_user)
  end
end
