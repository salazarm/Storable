class AddHostAcceptedColumnToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :host_accepted, :boolean
  end
end
