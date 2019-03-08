class AddCapacityToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :capacity, :integer
  end
end
