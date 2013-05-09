class AddColumnToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :host_seen, :boolean
  end
end
