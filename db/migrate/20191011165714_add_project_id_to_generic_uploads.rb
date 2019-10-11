class AddProjectIdToGenericUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :generic_uploads, :project_id, :string
  end
end
