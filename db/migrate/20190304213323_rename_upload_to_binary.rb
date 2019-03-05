class RenameUploadToBinary < ActiveRecord::Migration[5.2]
  def change
    rename_column :generic_uploads, :upload_data, :binary_data
  end
end
