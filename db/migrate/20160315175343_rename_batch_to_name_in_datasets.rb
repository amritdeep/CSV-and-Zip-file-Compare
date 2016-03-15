class RenameBatchToNameInDatasets < ActiveRecord::Migration
  def change
  	rename_column :batches, :batch, :name
  end
end
