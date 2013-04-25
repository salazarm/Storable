class MessagesController < ApplicationController
  respond_to :json
  before_filter :require_login, :get_or_create_conversation
  # GET /messages
  # GET /messages.json
  def index
    @messages = @conversation.messages.all

    respond_with(@messages, :status => :ok)
  end


  # POST /messages
  # POST /messages.json
  def create
    @message = @conversation.messages.new(params[:message])

    if @message.save
      respond_with(@message, :status => :created)
    else
      respond_with(@message.errors, :status => :unprocessable_entity)
    end

  end


  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = @conversation.messages.find(params[:id])
    if @message.destroy
        respond_with :status => :ok
    else
        respond_with(@message.errors, :status => :unprocessable_entity)
    end
  end

  protected
  def get_or_create_conversation
    #user_id is equal to the id of the person that this message is directed towards
    if params[:listing_id] && params[:message_receiver_id]
      listing = Listing.find(params[:listing_id])
      #this message is from the host to the renter
      if current_user.id == listing.user_id
        @conversation = Conversation.where(:host_id => current_user, :renter_id => params[:message_receiver_id], :listing_id => params[:listing_id]).first
      elsif params[:message_receiver_id] == listing.user_id #this message is from the renter to the host
        @conversation = Conversation.where(:host_id => User.find(listing.user_id), :renter_id => current_user.id, :listing_id => params[:listing_id]).first
      
        #if no conversation exists between this renter and host, then create one
        #note that this blank check is only done here since only the renter can initiate a message
        if @conversation.blank?
            @conversation = Conversation.new(:host_id => User.find(listing.user_id), :renter_id => current_user.id, :listing_id => params[:listing_id])
            @conversation.save
        end
      end
    end

    redirect_to root_url unless defined?(@conversation)
      
  end
end
