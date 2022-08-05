class Comment < ApplicationRecord
  belongs_to :post, dependent: :destroy
  has_rich_text :content

  # TODO: probably need to ad some relation to make REPLY comments
  validates :content, presence: true
end
