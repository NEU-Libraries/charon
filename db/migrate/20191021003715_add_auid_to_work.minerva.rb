# This migration comes from minerva (originally 20190107164946)
class AddAuidToWork < ActiveRecord::Migration[5.2]
  def change
    add_column :minerva_works, :auid, :string
  end
end
