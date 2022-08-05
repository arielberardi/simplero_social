class Post < ApplicationRecord
  has_many :comments

  has_rich_text :content

  # TODO: Title should be unique within the same group
  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
end
