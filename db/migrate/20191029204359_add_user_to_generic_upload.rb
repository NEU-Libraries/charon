class AddUserToGenericUpload < ActiveRecord::Migration[5.2]
  def change
    add_column :generic_uploads, :user_id, :integer
    add_foreign_key :generic_uploads, :users
  end
end
