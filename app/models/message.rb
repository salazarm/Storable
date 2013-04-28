class Message < ActiveRecord::Base
	attr_accessible :content, :is_starred, :is_read, :title
	belongs_to :user
	belongs_to :conversation
end
