# frozen_string_literal: true

# This migration comes from minerva (originally 20181218183524)
class CreateMinervaStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :minerva_statuses do |t|
      t.string :title

      t.timestamps
    end
  end
end
