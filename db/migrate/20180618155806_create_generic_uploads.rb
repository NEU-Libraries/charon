class CreateGenericUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :generic_uploads do |t|

      t.timestamps
    end
  end
end
