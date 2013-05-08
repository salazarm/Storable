class AddColumnToTransactions2 < ActiveRecord::Migration
  def change
    add_column :transactions, :listing_id, :integer
  end
end
