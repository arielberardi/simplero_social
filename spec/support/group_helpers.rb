# frozen_string_literal: true

require 'rails_helper'

def enroll_user_in_group(user, group, joined: true)
  GroupEnrollment.create(user: user, group: group, joined: joined)
end
