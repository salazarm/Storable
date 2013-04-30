module ApplicationHelper
	def newUser
		return User.new
	end

	def new_messages_count
		if @current_user
			return @current_user.host_conversations.where(:host_read => false).count + @current_user.renter_conversations.where(:renter_read => :false).count
		else
			return 0
		end
	end

	def profile_picture_for(user)
		return user.images.last ? user.images.last.location : user.photo
	end

	def pretty_name(user)
		user.first_name.nil? ? user.email : user.first_name + " " + user.last_name
	end
end
