# frozen_string_literal: true

module GroupsHelper
  def group_form_submit_name(action_name)
    action_name == 'edit' ? 'Save' : 'Create'
  end

  def group_form_title(action_name)
    action_name == 'edit' ? 'Edit' : 'Create'
  end

  def group_actions(group)
    return if current_owner?(group)

    enrollment = GroupEnrollment.find_by(user: current_user, group: group)

    return button_tag 'Joined', class: 'btn-primary' if enrollment&.joined == true
    return button_tag 'Waiting for access', class: 'btn-secondary' if enrollment&.joined == false

    if group.restricted?
      link_to 'Request join', request_group_path(group), class: 'btn-secondary'
    else
      link_to 'Join', join_group_path(group), class: 'btn-secondary'
    end
  end
end
