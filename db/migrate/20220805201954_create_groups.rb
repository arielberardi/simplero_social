# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :title, null: false, default: ''
      t.index :title, unique: true

      t.timestamps
    end
  end
end
