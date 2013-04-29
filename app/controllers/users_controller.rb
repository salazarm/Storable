class UsersController < ApplicationController
	respond_to :json, :html

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def create
     user = User.new(params[:user])
     if user.save
       session[:user_id] = user.id
       render :json => user, :only => ["id" ,"email"], :status => 200
     else
       render :json => user.errors, :status => 500
     end
  end

  def show
   	@user = User.find(params[:id])
   	respond_with(@user, :status => :ok)
  end

  def edit
    require_login
    @user = @current_user
  end

  def update
    require_login
    @user = @current_user

    if @user.update_attributes(params[:user])
      respond_with(@user, :status => :ok)
    else
      respond_with(@user.errors, :status => :unprocessable_entity)
    end
  end

end