class Conversation < ActiveRecord::Base
  attr_accessible :name, :host_id, :renter_id
  belongs_to :listing

  belongs_to :host, :class_name => "User", :foreign_key => "host_id"
  belongs_to :renter, :class_name => "User", :foreign_key => "renter_id"


  has_many :messages
end