class ConversationsController < ApplicationController
  respond_to :json, :html
  # respond_to :html, :only => [ :show ]
  before_filter :require_login

  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = @current_user.conversationsToJSON
    respond_with(@conversations, :status => :ok)
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    if current_user.host_conversations.exists?(:id => params[:id])
      @conversation = current_user.host_conversations.find(params[:id])
      @conversation.update_column(:host_read, true)
    elsif current_user.renter_conversations.exists?(:id => params[:id])
      @conversation = current_user.renter_conversations.find(params[:id])
      @conversation.update_column(:renter_read, true)
    end
    respond_with(@conversation, :status => :ok)
  end

  # Update is only used for starring messages
  def update
    Rails.cache.clear
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
