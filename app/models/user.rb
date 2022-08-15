# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  has_many :groups, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :group_enrollements, dependent: :destroy
  has_many :joined_groups, through: :group_enrollements, source: :group

  def name
    "#{first_name.first.capitalize}. #{last_name}"
  end
end
