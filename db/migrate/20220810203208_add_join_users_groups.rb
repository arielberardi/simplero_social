# frozen_string_literal: true

class AddJoinUsersGroups < ActiveRecord::Migration[7.0]
  def change
    create_table 'group_enrollements' do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.references :group, index: true, null: false, foreign_key: true
      t.boolean :joined

      t.timestamps
    end

    add_index :group_enrollements, %i[user_id group_id], unique: true
  end
end
