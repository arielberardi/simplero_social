# frozen_string_literal: true

require 'rails_helper'

def enroll_user_in_group(user, group)
  GroupEnrollement.create(user: user, group: group, joined: true)
end
