class SessionsController < ApplicationController
  def new
  end

  def create
   user = User.find_by_email(params[:email])
   if user && user.authenticate(params[:password])
     session[:user_id] = user.id
     render :json => user, :only => ["id" ,"email"], :status => 200
   else
     render :json => {:msg => "Invalid Login"}, :status => 404
   end
  end

  def destroy
   session[:user_id] = nil
   render :json => {:msg => "Logged Out!"}, :status => 200
  end
end