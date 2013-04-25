class Location < ActiveRecord::Base
	attr_accessible :street, :city, :state, :zip
	belongs_to :listing
end