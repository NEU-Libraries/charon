class AddDesignationToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :designation, :string
  end
end
