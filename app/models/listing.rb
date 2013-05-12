class Listing < ActiveRecord::Base
	attr_accessible :title, :description, :price, :size, :start_date, :end_date 

    belongs_to :user
    has_one :location
    has_many :conversations
	  has_many :images, :as => :imageable

    has_many :reserved_dates

    has_many :transaction_reviews, :foreign_key => :listing_id

    #make sure to include referenced classes in the json representation
    def as_json(options={})
      super(:include =>[:images, :location, :reserved_dates, :transaction_reviews])
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

    #This method returns true if this current user can still review this listing. Since a user can book a listing multiple times
    #we check if the number of transactions - number of reviews >= 1. This implies that the user can still review this place
    def can_review(current_user)
      #get number of transactions for this user and this listing
      num_transactions = Transaction.where(:listing_id => self[:id], :renter_id => current_user.id, :host_accepted => true).size

      #get number of reviews for this user and this listing
      num_reviews = self.transaction_reviews.where(:reviewer_id => current_user.id).size
    
      return (num_transactions - num_reviews) >= 1
    end

    #This method searches through all the listings based on the filters that are passed in
    def self.search(search_params)

        #get the address and radius --> THESE ARE REQUIRED
        address = search_params[:address]
        radius = search_params[:radius]

        #first filter by locations within radius miles of the given address
        locations = Location.near(address, radius)

        #if start date is passed in as a paramter then filter by that as well
        if search_params.has_key?(:start_date)

           #get the start date
           start_date = Date.parse(search_params[:start_date])

           #find all locations that have a start date earlier than the one passed in
           locations = locations.joins(:listing).where('listings.start_date <= ?', start_date)

           #find all listings that have reservations which conflict with the start date given
           #these constitute one of the exclusion sets
           exclusions_start = Listing.joins(:reserved_dates).where('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',start_date,start_date)
        end

        #if end date is passed in as a paramter then filter by that as well
        if search_params.has_key?(:end_date)

           #get the end date
           end_date = Date.parse(search_params[:end_date])

           #find all locations that have a end date later than the one passed in
           locations = locations.joins(:listing).where('listings.end_date >= ?', end_date)

           #find all listings that have reservations which conflict with the end date given
           #these constitute the second of the exclusion sets
           exclusions_end = Listing.joins(:reserved_dates).where('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',end_date,end_date)

        end

        #if space is passed in as a parameter, then further filter the locations 
        if search_params.has_key?(:space)
          locations = locations.joins(:listing).where('listings.size > ?', search_params[:space])
        end

        #collect all the listing ids
        listing_ids = locations.collect(&:listing_id) 

        #exclude all listings that conflict in terms of reserved dates
        if defined?(exclusions_start) && !exclusions_start.nil?
          listing_ids = listing_ids - exclusions_start.collect(&:id)
        end

        if defined?(exclusions_end) && !exclusions_end.nil?
          listing_ids = listing_ids - exclusions_end.collect(&:id)
        end

        #find all the listing objects and return them
        listings = []
        listing_ids.each do |listing_id|
            listings.push(Listing.find(listing_id))
        end

        return listings.compact
    end


end