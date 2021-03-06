class UsersController < ApplicationController
	respond_to :json, :html

  # get ready to create a new user
  def new
    @user = User.new

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  # create a new user
  def create
     user = User.new(params[:user])
     if user.save
       session[:user_id] = user.id
       redirect_to root_url
     else
       render :json => user.errors, :status => 500
     end
  end

  # show a user
  def show
   	@user = User.find(params[:id])
   	respond_with(@user, :status => :ok)
  end

  # edit a user
  def edit
    require_login
    @user = @current_user
  end

  # update a user
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