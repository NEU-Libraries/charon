# This migration comes from minerva (originally 20190103213731)
class CreateMinervaWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :minerva_works do |t|

      t.timestamps
    end
  end
end
