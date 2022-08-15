# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def validate_ownership!(object)
    return if object.is_a?(Comment) && object.post.group.user == current_user
    return if object.is_a?(Post) && object.group.user == current_user

    head :unauthorized unless current_user == object.user
  end

  def validate_user_enrollment!
    redirect_to groups_url unless @group.users.include?(current_user)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end
end
