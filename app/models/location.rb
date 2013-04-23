class Location < ActiveRecord::Base
	attr_accessible :name, :street_1, :street_2
	belongs_to :listing
end