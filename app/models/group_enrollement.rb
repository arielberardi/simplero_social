# frozen_string_literal: true

class GroupEnrollement < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :user, uniqueness: { scope: :group }
end
