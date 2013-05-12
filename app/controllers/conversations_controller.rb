class ConversationsController < ApplicationController
  respond_to :json, :html
  before_filter :require_login

  # get all conversations associated with user
  def index
    @conversations = @current_user.conversationsToJSON
    respond_with(@conversations, :status => :ok)
  end

  # show a conversation
  def show
    # determine if user is host or renter of conversation, or neither 
    if current_user.host_conversations.exists?(:id => params[:id])
      @conversation = current_user.host_conversations.find(params[:id])
      @conversation.update_column(:host_read, true)
    elsif current_user.renter_conversations.exists?(:id => params[:id])
      @conversation = current_user.renter_conversations.find(params[:id])
      @conversation.update_column(:renter_read, true)
    else
      respond_with("You are not the host or renter of this conversation", :status => :unprocessable_entity)
    end
    respond_with(@conversation, :status => :ok)
  end

  # update a conversation
  # NOTE: update is only used for starring messages
  def update
    
    Rails.cache.clear

    # determine if user is host or renter of conversation, or neither 
    if current_user.host_conversations.exists?(:id => params[:id])
      @conversation = current_user.host_conversations.find(params[:id])
      if @conversation.update_attributes({:host_starred => params[:star]})
        render :json => true
      else
        render :json => { "error" => "Could not star message" }, :status => 500
      end
    elsif current_user.renter_conversations.exists?(:id => params[:id])
      @conversation = current_user.renter_conversations.find(params[:id]) 
      if @conversation.update_attributes({:renter_starred => params[:star]})
        render :json => true
      else
        render :json => { "error" => "Could not star message" }, :status => 500
      end
    else
      redirect_to root_url
    end
  end
end
