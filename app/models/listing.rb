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


    #takes a bunch of parameters and searches through listings for them
    def self.search(search_params)
        address = search_params[:address]
        radius = search_params[:radius]

        #first filter by locations within radius miles of the given address
        locations = Location.near(address, radius)

        #if start date is passed in as a paramter then filter by that as well
        if search_params.has_key?(:start_date)
           start_date = search_params[:start_date]


           locations = locations.joins(:listing).where('listings.start_date <= ?', start_date).group('listings.id')

           exclusions_start = Listing.joins(:reserved_dates).having('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',start_date,start_date).group('listings.id')
        end

        if search_params.has_key?(:end_date)
           end_date = search_params[:end_date]
           locations = locations.joins(:listing).where('listings.end_date >= ?', end_date).group('listings.id')

           exclusions_end = Listing.joins(:reserved_dates).having('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',end_date,end_date).group('listings.id')
        end


        if search_params.has_key?(:space)
          locations = locations.where('listings.size > ?', search_params[:space])
        end


        if defined?(exclusions_start) && !exclusions_start.nil?
          locations = locations - exclusions_start
        elsif defined?(exclusions_end) && !exclusions_end.nil?
          locations = locations - exclusions_end
        end


        listings = []
        locations.each do |location| 
            listings.push(location.listing)
        end

        return listings
    end

end