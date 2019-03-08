class AddReferencesToRole < ActiveRecord::Migration[5.2]
  def change
    add_reference :roles, :user_registry, index: true
    add_reference :roles, :user, index: true
  end
end
