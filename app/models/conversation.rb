class Conversation < ActiveRecord::Base
  
  attr_accessible :host_id, :renter_id, :listing_id, 
                  :renter_starred, :host_starred,
                  :renter_read, :host_read

  attr_readonly :host_id, :renter_id, :listing_id
  belongs_to :listing

  belongs_to :host, :class_name => "User", :foreign_key => "host_id"
  belongs_to :renter, :class_name => "User", :foreign_key => "renter_id"
  has_many :messages

  def as_json(options={})
      super(:include =>[:messages])
  end

  def read
    update_attribute(:is_read, true)
  end
end