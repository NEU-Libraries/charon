class CreateUserRegistries < ActiveRecord::Migration[5.2]
  def change
    create_table :user_registries do |t|

      t.timestamps
    end
  end
end
