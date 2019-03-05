class RemoveGenericsFromGenericUploads < ActiveRecord::Migration[5.2]
  def change
    remove_column :generic_uploads, :generics
  end
end
