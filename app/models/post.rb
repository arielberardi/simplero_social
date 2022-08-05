class Post < ApplicationRecord
  belongs_to :group
  has_many :comments, dependent: :destroy

  has_rich_text :content

  # TODO: Title should be unique within the same group
  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
end
