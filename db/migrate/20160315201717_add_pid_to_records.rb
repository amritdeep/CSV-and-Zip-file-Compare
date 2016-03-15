class AddPidToRecords < ActiveRecord::Migration
  def change
    add_column :records, :pid, :string
  end
end
