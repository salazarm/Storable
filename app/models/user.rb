class User < ActiveRecord::Base
  attr_accessible :email, :about, :password, :password_confirmation
  has_secure_password

  has_many :listings
  has_many :messages
  has_one :image, :as => :imageable

  validates_confirmation_of :email
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
end