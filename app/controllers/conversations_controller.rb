class ConversationsController < ApplicationController
  respond_to :json
  before_filter :require_login

  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = current_user.conversations.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conversations }
    end
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    @conversation = current_user.conversation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conversation }
    end
  end


  # POST /conversations
  # POST /conversations.json
  def create
    @conversation = current_user.conversation.new(params[:conversation])

    respond_to do |format|
      if @conversation.save
        format.html { redirect_to @conversation, notice: 'conversation was successfully created.' }
        format.json { render json: @conversation, status: :created, location: @conversation }
      else
        format.html { render action: "new" }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conversations/1
  # PUT /conversations/1.json
  def update
    @conversation = current_user.conversation.find(params[:id])

    respond_to do |format|
      if @conversation.update_attributes(params[:conversation])
        format.html { redirect_to @conversation, notice: 'conversation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /conversations/1
  # # DELETE /conversations/1.json
  # def destroy
  #   @conversation = conversation.find(params[:id])
  #   @conversation.destroy

  #   respond_to do |format|
  #     format.html { redirect_to conversations_url }
  #     format.json { head :no_content }
  #   end
  # end
end
