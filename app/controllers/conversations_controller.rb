class ConversationsController < ApplicationController
  respond_to :json
  before_filter :require_login

  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = current_user.host_conversations.all + current_user.renter_conversations.all

    respond_with(@conversations, :status => :ok)
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    if current_user.host_conversations.exists?(:id => params[:id])
      @conversation = current_user.host_conversations.find(params[:id])
    elsif current_user.renter_conversations.exists?(:id => params[:id])
      @conversation = current_user.renter_conversations.find(params[:id])
    end
    

    respond_with(@conversation, :status => :ok)
  end

end
