class Message < ActiveRecord::Base

	attr_accessible :content
	belongs_to :user
	belongs_to :conversation

	after_save :touch_conversation

	def touch_conversation
		conversation.touch
		conversation.is_read = false
	end

end
