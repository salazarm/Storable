class Listing < ActiveRecord::Base
	attr_accessible :title, :description, :price, :size, :start_date, :end_date
	has_one :location
    has_many :conversations
	has_many :images, :as => :imageable
end