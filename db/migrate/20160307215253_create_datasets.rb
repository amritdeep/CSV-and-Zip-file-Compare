class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.string :dataset_name
      t.text :description
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_attachment :datasets, :file
    add_attachment :datasets, :zipfile
  end
end
