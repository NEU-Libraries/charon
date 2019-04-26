class AddProjectIdToUserRegistries < ActiveRecord::Migration[5.2]
  def change
    add_column :user_registries, :project_id, :string
  end
end
