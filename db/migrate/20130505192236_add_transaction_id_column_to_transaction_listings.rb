class AddTransactionIdColumnToTransactionListings < ActiveRecord::Migration
  def change
  	add_column :transaction_listings, :transaction_id, :integer
  	add_column :transactions, :stripeToken, :string
  end
end
