class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_user

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user


  private
  #makes sure that the user is logged in, else redirects to login page
  def require_login
    unless current_user
      redirect_to root_url, :notice => "You must be logged in to access this section"
    end
  end
  
end