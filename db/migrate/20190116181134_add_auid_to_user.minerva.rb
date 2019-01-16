# This migration comes from minerva (originally 20190107164940)
class AddAuidToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :minerva_users, :auid, :string
  end
end
