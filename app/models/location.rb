class Location < ActiveRecord::Base
	attr_accessible :street, :city, :state, :zip, :latitude, :longitude
	belongs_to :listing
    geocoded_by :full_street_address
    after_validation :geocode

    # return pretty representation of location
    def full_street_address
        return [street, city, state, zip].compact.join(', ')
    end 

    validates_presence_of :street
    validates_presence_of :city
    validates_presence_of :state
    validates_presence_of :zip
end