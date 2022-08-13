# frozen_string_literal: true

class AddTypeToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :privacy, :integer, null: false
  end
end
