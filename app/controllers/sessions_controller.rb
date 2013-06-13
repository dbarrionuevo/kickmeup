class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    if user.save
      session[:user_id] = user.id
      redirect_to root_url, notice: "Welcome #{user.name}!"
    else
      redirect_to root_url, notice: user.errors.full_messages
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
