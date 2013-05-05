class AddStartDateEndDateToTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :start_date, :date
  	add_column :transactions, :end_date, :date
  end
end
