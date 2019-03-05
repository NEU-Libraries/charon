class AddUploadDataToGenericUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :generic_uploads, :upload_data, :text
  end
end
