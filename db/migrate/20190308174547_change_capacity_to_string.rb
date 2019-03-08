class ChangeCapacityToString < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :capacity, :string
  end
end
