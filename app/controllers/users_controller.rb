class UsersController < ApplicationController

   def create
     user = User.new(params[:user])
     if user.save
       session[:user_id] = user.id
       render :json => user, :only => ["id" ,"email"], :status => 200
     else
       render :json => user.errors, :status => 500
   end

 end
end