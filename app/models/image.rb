class Image < ActiveRecord::Base
	attr_accessible :location
	belongs_to :imageable, :polymorphic => true
end