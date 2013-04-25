class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /^.+@.+\..+$/i 
  attr_accessible :email, :about, :password, :password_confirmation
  has_secure_password


  has_many :listings
  has_many :messages
  has_one :image, :as => :imageable

  before_validation :downcase_email
  validates :email, :uniqueness => true, 
             :format => {:with => VALID_EMAIL_REGEX }

  validates_confirmation_of :email
  validates_presence_of :password, :on => :create
 
  HUMANIZED_ATTRIBUTES = {
    :password_digest => "Password"
  }

  def as_json(options={})
    super(:only => [:email, :id])
  end

  # Downcase email because emails are usually not case sensitive
  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

   # Overrides humanized attribute names
  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end