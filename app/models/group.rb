# frozen_string_literal: true

class Group < ApplicationRecord
  enum :privacy, %i[open restricted]

  belongs_to :user
  has_many :posts, dependent: :destroy

  has_many :group_enrollments, dependent: :destroy
  has_many :users, through: :group_enrollments, source: :user

  validates :title, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :privacy, presence: true

  def requests
    group_enrollments.where(joined: false).map(&:user)
  end

  def members
    group_enrollments.where(joined: true).map(&:user)
  end
end
