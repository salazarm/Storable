class ConversationsController < ApplicationController
  respond_to :json, :html
  # respond_to :html, :only => [ :show ]
  before_filter :require_login

  # GET /conversations
  # GET /conversations.json
  def index
    # @conversations = @current_user.conversationsToJSON
    host_convos    = current_user.host_conversations.all.sort_by(&:updated_at).reverse
    rentee_convos  = current_user.renter_conversations.all.sort_by(&:updated_at).reverse
    all_convos = (host_convos+rentee_convos).sort_by(&:updated_at).reverse
    @conversations = {
          :host_conversations => host_convos,
          :rentee_conversations => rentee_convos,
          :all_conversations => all_convos
        }

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
    if current_user.host_conversations.exists?(:id => params[:id])
      @conversation = current_user.host_conversations.find(params[:id])
      begin @conversation.update_column(:host_starred, params[:listing][:starred])
        respond_with(@conversation, :status => :ok)
      rescue ActiveRecordError
        render :json => { "error" : "Could not star message" }, :status => 500
      end
    elsif current_user.renter_conversations.exists?(:id => params[:id])
      @conversation = current_user.renter_conversations.find(params[:id]) 
      begin @conversation.update_column(:renter_starred, params[:listing][:starred])
        respond_with(@conversation, :status => :ok)
      rescue ActiveRecordError
        render :json => { "error" : "Could not star message" }, :status => 500
      end
    else
      redirect_to root_url
    end
  end
end
