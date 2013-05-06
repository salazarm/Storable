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


    #tThis method searches through all the listings based on the filters that are passed in
    def self.search(search_params)

        #get the address and radius --> THESE ARE REQUIRED
        address = search_params[:address]
        radius = search_params[:radius]

        #first filter by locations within radius miles of the given address
        locations = Location.near(address, radius)

        #if start date is passed in as a paramter then filter by that as well
        if search_params.has_key?(:start_date)

           #get the start date
           start_date = search_params[:start_date]

           #find all locations that have a start date earlier than the one passed in
           locations = locations.joins(:listing).where('listings.start_date <= ?', start_date).group('listings.id')

           #find all listings that have reservations which conflict with the start date given
           #these constitute one of the exclusion sets
           exclusions_start = Listing.joins(:reserved_dates).having('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',start_date,start_date).group('listings.id')
        end

        #if end date is passed in as a paramter then filter by that as well
        if search_params.has_key?(:end_date)

           #get the end date
           end_date = search_params[:end_date]

           #find all locations that have a end date later than the one passed in
           locations = locations.joins(:listing).where('listings.end_date >= ?', end_date).group('listings.id')

           #find all listings that have reservations which conflict with the end date given
           #these constitute the second of the exclusion sets
           exclusions_end = Listing.joins(:reserved_dates).having('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',end_date,end_date).group('listings.id')
        end

        #if space is passed in as a parameter, then further filter the locations 
        if search_params.has_key?(:space)
          locations = locations.joins(:listing).where('listings.size > ?', search_params[:space])
        end

        #subtract the exclusion sets
        if defined?(exclusions_start)
          locations = locations - exclusions_start
        elsif 
          locations = locations - exclusions_end
        end

        #find the listings corresponding to the locations and return that
        listings = []
        locations.each do |location| 
            listings.push(location.listing)
        end

        return listings
    end

end