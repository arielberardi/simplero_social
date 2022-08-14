# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

  has_rich_text :content

  validates :content, presence: true

  scope :parents, -> { where(parent_id: nil) }

  def reply?
    !parent.nil?
  end
end
