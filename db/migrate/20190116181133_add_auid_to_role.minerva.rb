# frozen_string_literal: true

# This migration comes from minerva (originally 20190107164934)
class AddAuidToRole < ActiveRecord::Migration[5.2]
  def change
    add_column :minerva_roles, :auid, :string
  end
end
