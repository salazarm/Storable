class Listing < ActiveRecord::Base
	attr_accessible :title, :description, :price, :size, :start_date, :end_date 

    belongs_to :user
	has_one :location
    has_many :conversations
	has_many :images, :as => :imageable

    def as_json(options={})
      super(:include =>[:images])
    end

end