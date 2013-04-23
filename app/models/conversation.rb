class Conversation < ActiveRecord::Base
	attr_accessible :name, :host_id, :renter_id
	has_many :messages
end