# This migration comes from minerva (originally 20191106053529)
class RemoveRole < ActiveRecord::Migration[5.2]
  def change
    remove_index :minerva_states, :role_id
    remove_column :minerva_states, :role_id
    drop_table :minerva_roles
  end
end
