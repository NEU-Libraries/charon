class RemoveBinaryDataFromGenericUploads < ActiveRecord::Migration[5.2]
  def change
    remove_column :generic_uploads, :binary_data
  end
end
