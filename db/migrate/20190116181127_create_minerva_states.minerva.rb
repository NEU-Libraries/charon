# frozen_string_literal: true

# This migration comes from minerva (originally 20181218183815)
class CreateMinervaStates < ActiveRecord::Migration[5.2]
  def change
    create_table :minerva_states do |t|
      t.integer :creator_id
      t.integer :user_id
      t.integer :role_id
      t.integer :work_id
      t.integer :minerva_assignment_id
      t.integer :minerva_status_id

      t.timestamps
    end
    add_index :minerva_states, :creator_id
    add_index :minerva_states, :user_id
    add_index :minerva_states, :role_id
    add_index :minerva_states, :work_id

    add_foreign_key :minerva_states, :minerva_assignments, column: :minerva_assignment_id
    add_index :minerva_states, :minerva_assignment_id
    add_foreign_key :minerva_states, :minerva_statuses, column: :minerva_status_id
    add_index :minerva_states, :minerva_status_id
  end
end
