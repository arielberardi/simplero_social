# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :comments, dependent: :destroy

  has_rich_text :content

  validates :title, presence: true, uniqueness: { scope: :group_id }
  validates :content, presence: true
end
