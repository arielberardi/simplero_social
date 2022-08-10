# frozen_string_literal: true

class AddUsersToGroupPostComment < ActiveRecord::Migration[7.0]
  def change
    add_reference :groups, :user, index: true, null: false, foreign_key: true
    add_reference :posts, :user, index: true, null: false, foreign_key: true
    add_reference :comments, :user, index: true, null: false, foreign_key: true
  end
end
