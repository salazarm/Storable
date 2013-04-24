class MessagesController < ApplicationController
  respond_to :json
  before_filter :require_login, :get_conversation
  # GET /messages
  # GET /messages.json
  def index
    @messages = @conversation.messages.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = @conversation.messages.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = @conversation.messages.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = @conversation.messages.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = @conversation.messages.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  protected
  def get_conversation
      @conversation = current_user.conversation.find(params[:conversation_id]) if params[:conversation_id]
      redirect_to root_url unless defined?(@conversation)
  end
end
