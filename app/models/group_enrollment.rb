# frozen_string_literal: true

class GroupEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user, uniqueness: { scope: :group }
end
