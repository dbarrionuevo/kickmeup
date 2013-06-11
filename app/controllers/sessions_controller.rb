class SessionsController < ApplicationController
  def create
    session[:auth] = env["omniauth.auth"].slice(:uid, :info)
    redirect_to root_url, info: 'Successfully logged in!'
  end

  def destroy
    session[:auth] = nil
    redirect_to root_url
  end
end