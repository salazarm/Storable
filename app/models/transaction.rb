class Transaction < ActiveRecord::Base
  attr_accessible :host_id, :renter_id, :stripeToken, :host_accepted, :start_date, :end_date

  has_one :transaction_listing

  belongs_to :renter, :class_name => "User", :foreign_key => "renter_id"
  belongs_to :host, :class_name => "User", :foreign_key => "host_id"

  def self.create_transaction_listing(listing, transaction)
  	transaction.build_transaction_listing(
      :listing_id => listing.id,
      :title => listing.title,
      :description => listing.description,
      :user_id => listing.user_id,
      :price => listing.price,
      :size => listing.size,
      :start_date => listing.start_date,
      :end_date => listing.end_date)
  end

end