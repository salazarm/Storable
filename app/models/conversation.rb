class Conversation < ActiveRecord::Base
  
  attr_accessible :host_id, :renter_id, :listing_id, 
                  :renter_starred, :host_starred,
                  :renter_read, :host_read, :request_submitted
                  

  attr_readonly :host_id, :renter_id, :listing_id
  belongs_to :listing

  belongs_to :host, :class_name => "User", :foreign_key => "host_id"
  belongs_to :renter, :class_name => "User", :foreign_key => "renter_id"
  has_many :messages

  def as_json(options={})
      super(:include =>[:messages])
  end

  def self.create_or_get_conversation(params, current_user)
    #user_id is equal to the id of the person that this message is directed towards
    listing = Listing.find(params[:listing_id])
    if listing
      #this message is from the host to the renter
      if current_user.id == listing.user_id
        @conversation = Conversation.where(:host_id => current_user.id, :renter_id => params[:renter_id], :listing_id => listing.id).first
      else #this message is from the renter to the host
        @conversation = Conversation.where(:host_id => listing.user_id, :renter_id => current_user.id, :listing_id => listing.id).first
        #if no conversation exists between this renter and host, then create one
        #note that this blank check is only done here since only the renter can initiate a message
        if @conversation.blank?  
            @conversation = Conversation.new(:host_id => listing.user_id, :renter_id => current_user.id, :listing_id => listing.id)
            @conversation.save
        end
      end
    end
    return defined?(@conversation).nil? ? nil : @conversation
  end

  def read
    update_attribute(:is_read, true)
  end

  def request_submit
    update_attribute(:request_submitted, true)
  end
end