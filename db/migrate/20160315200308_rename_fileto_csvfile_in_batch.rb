class RenameFiletoCsvfileInBatch < ActiveRecord::Migration
  def change
	rename_column :batches, :file_file_name, :csvfile_file_name
	rename_column :batches, :file_content_type, :csvfile_content_type
	rename_column :batches, :file_file_size, :csvfile_file_size
	rename_column :batches, :file_updated_at, :csvfile_updated_at
  end
end


