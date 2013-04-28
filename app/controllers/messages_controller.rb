class MessagesController < ApplicationController
  respond_to :json
  before_filter :require_login, :get_or_create_conversation

  # POST /messages
  # POST /messages.json
  def create
    @message = @conversation.messages.new(params[:message])
    @message.user_id = @current_user.id

    if @message.save
      respond_with(@message, :status => :created)
    else
      respond_with(@message.errors, :status => :unprocessable_entity)
    end

  end


  protected
  def get_or_create_conversation
    #user_id is equal to the id of the person that this message is directed towards
    listing = Listing.find(params[:listing_id])
    if listing
      #this message is from the host to the renter
      if @current_user.id == listing.user_id
        @conversation = Conversation.where(:host_id => @current_user.id, :renter_id => listing.user_id, :listing_id => listing.id).first
      else #this message is from the renter to the host
        @conversation = Conversation.where(:host_id => listing.user_id, :renter_id => @current_user.id, :listing_id => listing.id).first
        #if no conversation exists between this renter and host, then create one
        #note that this blank check is only done here since only the renter can initiate a message
        if @conversation.blank?  
            @conversation = Conversation.new(:host_id => listing.user_id, :renter_id => @current_user.id, :listing_id => listing.id)
            @conversation.save
        end
      end
    end

    redirect_to root_url unless defined?(@conversation)
      
  end
end
