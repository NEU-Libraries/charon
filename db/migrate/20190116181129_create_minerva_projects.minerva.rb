# This migration comes from minerva (originally 20190103213722)
class CreateMinervaProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :minerva_projects do |t|

      t.timestamps
    end
  end
end
