# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def validates_ownership!(object)
    head :unauthorized unless current_user.id == object.user.id
  end
end
