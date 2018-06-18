class AddGenericsToGenericUploads < ActiveRecord::Migration[5.1]
  def change
    add_column :generic_uploads, :generics, :string
  end
end
