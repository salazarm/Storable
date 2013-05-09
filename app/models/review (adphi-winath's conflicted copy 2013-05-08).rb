class Review < ActiveRecord::Base
	attr_accessible :reviewer_id, :content, :overall_rating, :quality_rating, 
		:transaction_id, :location_rating, :price_rating,
		:reviewee_id, :timeliness_rating, :responsiveness_rating

		belongs_to :reviewer, :class_name => "User", :foreign_key => "reviewer_id"
    belongs_to :listing, :class_name => "Listing", :foreign_key => "listing_id"
end