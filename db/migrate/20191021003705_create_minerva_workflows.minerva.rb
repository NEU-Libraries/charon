# This migration comes from minerva (originally 20181218183254)
class CreateMinervaWorkflows < ActiveRecord::Migration[5.2]
  def change
    create_table :minerva_workflows do |t|
      t.integer :creator_id
      t.integer :project_id
      t.text :task_list
      t.string :title
      t.boolean :ordered

      t.timestamps
    end
    add_index :minerva_workflows, :creator_id
    add_index :minerva_workflows, :project_id
  end
end
