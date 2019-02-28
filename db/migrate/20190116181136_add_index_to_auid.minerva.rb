# frozen_string_literal: true

# This migration comes from minerva (originally 20190107171954)
class AddIndexToAuid < ActiveRecord::Migration[5.2]
  def change
    add_index :minerva_projects, :auid, unique: true
    add_index :minerva_roles, :auid, unique: true
    add_index :minerva_users, :auid, unique: true
    add_index :minerva_works, :auid, unique: true
  end
end
