# frozen_string_literal: true

class Group < ApplicationRecord
  enum :privacy, %i[open restricted]

  belongs_to :user
  has_many :posts, dependent: :destroy

  has_many :group_enrollements, dependent: :destroy
  has_many :users, through: :group_enrollements, source: :user

  validates :title, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :privacy, presence: true

  def requests
    group_enrollements.where(joined: false).map(&:user)
  end

  def members
    group_enrollements.where(joined: true).map(&:user)
  end
end
