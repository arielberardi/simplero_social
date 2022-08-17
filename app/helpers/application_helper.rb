# frozen_string_literal: true

module ApplicationHelper
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
end
