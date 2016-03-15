class ChangeDataToNameInRecord < ActiveRecord::Migration
  def change
  	rename_column :records, :data, :name
  end
end
