class AddPostsToGroups < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :group, null: false, foreign_key: true, index: true
  end
end
