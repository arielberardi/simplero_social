class Post < ApplicationRecord
  has_rich_text :content

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
end
