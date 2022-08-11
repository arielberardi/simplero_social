# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def validate_ownership!(object)
    return if object.is_a?(Comment) && object.post.group.user == current_user
    return if object.is_a?(Post) && object.group.user == current_user

    head :unauthorized unless current_user == object.user
  end

  def validate_user_enrollment!
    redirect_to groups_url unless @group.users.include?(current_user)
  end
end
