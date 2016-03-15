class RenameDatasetsToBatches < ActiveRecord::Migration
  def change
  	rename_table :datasets, :batches
  end
end
