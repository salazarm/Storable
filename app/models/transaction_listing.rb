class TransactionListing < ActiveRecord::Base
  attr_accessible :description, :end_date, :price, :size, :start_date, :title, :user_id, :listing_id

  belongs_to :listing
  belongs_to :transaction
end
