class CreateGenericUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :generic_uploads do |t|
      t.string :generics

      t.timestamps
    end
  end
end
