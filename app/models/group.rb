# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :title, presence: true, uniqueness: true, length: { minimum: 2 }
end
