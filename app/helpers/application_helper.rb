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

  def group_actions(group)
    return if current_owner?(group)

    enrollement = GroupEnrollement.find_by(user: current_user, group: group)

    return button_tag 'Joined', class: 'btn-primary' if enrollement&.joined == true
    return button_tag 'Waiting for access', class: 'btn-secondary' if enrollement&.joined == false

    if group.restricted?
      link_to 'Request join', request_group_path(group), class: 'btn-secondary'
    else
      link_to 'Join', join_group_path(group), class: 'btn-secondary'
    end
  end
end
