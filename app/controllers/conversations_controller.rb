class ConversationsController < ApplicationController

  respond_to :json, :html
  before_filter :require_login

  # GET /conversations
  # GET /conversations.json
  def index
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
      @conversation.update_attribute(:host_read, true)
    elsif current_user.renter_conversations.exists?(:id => params[:id])
      @conversation = current_user.renter_conversations.find(params[:id])
      @conversation.update_attribute(:renter_read, true)
    end
    respond_with(@conversation, :status => :ok)
  end

  def update
    if current_user.host_conversations.exists?(:id => params[:id])
      @conversation = current_user.host_conversations.find(params[:id])
      @conversation.update_attribute(:renter_read, false)
    elsif current_user.renter_conversations.exists?(:id => params[:id])
      @conversation = current_user.renter_conversations.find(params[:id]) 
      @conversation.update_attribute(:host_read, false) 
    end

    if @conversation
      if @conversation.update_attributes(params[:listing])
        puts "it worked"
        respond_with(@conversation, :status => :ok)
      else
        respond_with(@conversation.errors, :status => :unplsecessable_entity)
      end
    else
      respond_with(@conversation, :status => :ok)
    end
  end
end
