class Listing < ActiveRecord::Base
	attr_accessible :title, :description, :price, :siez, :start_date, :end_date
	has_one :location
	has_many :images, :as => :imageable
end