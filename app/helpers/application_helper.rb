module ApplicationHelper
	def newUser
		return User.new
	end

	def new_messages_count
		if @current_user
			return @current_user.host_conversations.where('host_read != ?', true).count + @current_user.renter_conversations.where('renter_read != ?', true).count
		else
			return 0
		end
	end
end
