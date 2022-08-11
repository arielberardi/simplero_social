# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  has_many :group_enrollements, dependent: :destroy
  has_many :users, through: :group_enrollements, source: :user

  validates :title, presence: true, uniqueness: true, length: { minimum: 2 }
end
