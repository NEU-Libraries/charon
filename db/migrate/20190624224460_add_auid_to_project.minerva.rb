# This migration comes from minerva (originally 20190107164913)
class AddAuidToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :minerva_projects, :auid, :string
  end
end
