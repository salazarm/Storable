class User < ActiveRecord::Base
  DEFAULT_PHOTO = "https://a0.muscache.com/airbnb/static/user_pic-225x225-63c61cbeda6f7fa57047b852c5fb7e86.png"
  VALID_EMAIL_REGEX = /^.+@.+\..+$/i 
  attr_accessible :email, :about, :password, :password_confirmation, :first_name, :last_name
  
  has_secure_password

  has_many :listings
  has_many :messages
  has_many :images, :as => :imageable

  has_many :host_conversations, :class_name => "Conversation", :foreign_key => :host_id
  has_many :renter_conversations, :class_name => "Conversation", :foreign_key => :renter_id

  has_many :host_transactions, :class_name => "Transaction", :foreign_key => :host_id
  has_many :renter_transactions, :class_name => "Transaction", :foreign_key => :renter_id

  has_many :user_reviews, :foreign_key => :reviewer_id
  has_many :transaction_reviews, :foreign_key => :reviewee_id

  before_validation :downcase_email
  validates :email, :uniqueness => true, 
             :format => {:with => VALID_EMAIL_REGEX }

  validates_confirmation_of :email
  validates_presence_of :password, :on => :create
 
  HUMANIZED_ATTRIBUTES = {
    :password_digest => "Password"
  }

  # override method to only return email and user id
  def as_json(options={})
    super(:only => [:email, :id])
  end

  # Downcase email because emails are usually not case sensitive
  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

  # Returns a JSON object of conversations.
  # This is prefferred over the standard toJSON for each ebject
  # becaus we don't need to send all of the extra information
  # for a conversation overview and we don't wish to affect other
  # areas which might. 
  def conversationsToJSON

    convos = Array.new

    # loop through all conversations associated with user, convert to JSON
    (host_conversations+renter_conversations).sort_by(&:updated_at).reverse.each do |convo|

      # handle if user is renter or host
      if id == convo.renter_id
        read = convo.renter_read
        starred = convo.renter_starred
      else
        read = convo.host_read
        starred = convo.host_starred
      end

      convos.push({
        :id => convo.id,
        :read => read,
        :starred => starred,
        :listing_id => convo.listing_id,
        :listing_title => convo.listing.title,
        :address => convo.listing.location.full_street_address,
        :is_host => convo.listing.user_id == id,
        :content => convo.messages.last.content,
        :last_id => convo.messages.last.user_id,
        :last_name => convo.messages.last.user.pretty_name,
        :last_photo => convo.messages.last.user.profile_photo,
        :updated_at => convo.messages.last.created_at
      })
    end

    return convos
  end

  # returns user-friendly name of user
  def pretty_name
    first_name.nil? ? email : first_name + " " + last_name
  end

  # returns either the user's photo or the default photo (if user has no photo)
  # NOTE: user has many images to make polymorphic association work
  def profile_photo
    return images.last ? images.last.location : DEFAULT_PHOTO
  end

   # Overrides humanized attribute names
  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Returns true if this current user can still review this user. Since a user can book a 
  #   listing multiple times we check if (number of transactions) - (number of reviews) >= 1. 
  #   This implies that the user can still review this user.
  def can_review(current_user)
    # get number of transactions for this user and this host
    num_transactions = Transaction.where("(renter_id = ? AND host_id = ?) OR (renter_id = ? AND host_id = ?)", current_user.id,self.id, current_user.id, self.id).where(:host_accepted => true).size

    # get number of reviews for this user and this host
    num_reviews = self.user_reviews.where(:reviewer_id => current_user.id).size
  
    return (num_transactions - num_reviews) >= 1
  end

end