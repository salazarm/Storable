class AddListingIdToTransactionListing < ActiveRecord::Migration
  def change
  	add_column :transaction_listings, :listing_id, :integer
  end
end
