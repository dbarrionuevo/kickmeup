class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
  	@current_user = session[:auth] if session[:auth]
  end
  helper_method :current_user

  def authenticate_user!
  	redirect_to root_path, alert: 'Please sign in' unless current_user
  end
end
