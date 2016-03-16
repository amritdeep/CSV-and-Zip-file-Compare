class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.string :batch
      t.integer :user_id
      # t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_attachment :datasets, :csvfile
    add_attachment :datasets, :zipfile
  end
end
