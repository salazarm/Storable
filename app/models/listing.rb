class Listing < ActiveRecord::Base
	attr_accessible :title, :description, :price, :size, :start_date, :end_date 

    belongs_to :user
    has_one :location
    has_many :conversations
	has_many :images, :as => :imageable

    has_many :reserved_dates

    def as_json(options={})
      super(:include =>[:images, :location])
    end

    def create_reserved_date(transaction, listing)
	  reserved_date = listing.reserved_dates.build(
	  	:listing_id => listing.id,
	  	:renter_id  => transaction.renter_id,
	  	:start_date => transaction.start_date,
	  	:end_date   => transaction.end_date
      )
      reserved_date.save()
    end

end