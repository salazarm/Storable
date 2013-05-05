class ReservedDate < ActiveRecord::Base
  attr_accessible :end_date, :listing_id, :renter_id, :start_date

  belongs_to :renter, :class_name => "User", :foreign_key => "renter_id"
  belongs_to :listing
  
end
