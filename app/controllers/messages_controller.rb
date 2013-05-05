class MessagesController < ApplicationController
  respond_to :json
  before_filter :require_login, :get_or_create_conversation


  def create
    @message = @conversation.messages.new(params[:message])
    @message.user_id = @current_user.id
    if @message.save
      respond_with(@message, :status => :created)
    else
      respond_with(@message.errors, :status => :unprocessable_entity)
    end
  end


  def get_or_create_conversation
    @conversation = Conversation.create_or_get_conversation(params, @current_user)
    redirect_to root_url if @conversation.nil?
  end
end
