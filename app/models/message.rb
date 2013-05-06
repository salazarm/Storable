class Message < ActiveRecord::Base

	attr_accessible :content
	belongs_to :user
	belongs_to :conversation

	after_create :touch_conversation

	def touch_conversation
		if user.id == conversation.renter.id
			conversation.update_attribute(:host_read, false)
		else
			conversation.update_attribute(:renter_read, false)
		end
	end
end
