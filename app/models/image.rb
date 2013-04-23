class Image < ActiveRecord::Base
	attr_accessible :image_url
	belongs_to :imageable, :polymorphic => true
end