# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def validates_ownership!(object)
    return if object.is_a?(Comment) && object.post.group.user == current_user
    return if object.is_a?(Post) && object.group.user == current_user

    head :unauthorized unless current_user.id == object.user.id
  end
end
