# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_many :groups, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :group_enrollements, dependent: :destroy
  has_many :joined_groups, through: :group_enrollements, source: :group

  def name
    "#{first_name} #{last_name.first.capitalize}."
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
