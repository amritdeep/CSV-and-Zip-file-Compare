class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.text :data
      t.references :dataset, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
