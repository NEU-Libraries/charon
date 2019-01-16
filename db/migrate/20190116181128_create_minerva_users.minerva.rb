# This migration comes from minerva (originally 20190103213703)
class CreateMinervaUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :minerva_users do |t|

      t.timestamps
    end
  end
end
