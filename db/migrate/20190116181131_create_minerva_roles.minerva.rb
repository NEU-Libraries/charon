# This migration comes from minerva (originally 20190103213735)
class CreateMinervaRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :minerva_roles do |t|

      t.timestamps
    end
  end
end
