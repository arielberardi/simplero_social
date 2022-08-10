# frozen_string_literal: true

class AddPostsToGroups < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :group, null: false, foreign_key: true
    add_index :posts, %i[title group_id], unique: true
  end
end
