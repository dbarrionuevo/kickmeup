class UsersController < ApplicationController
  before_action :user

  def show
  end

  def select_friends
    @friendships = user.friendships
  end

  def invite_friends

  end

  private
  def user
    begin
      @user ||= User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Invalid User"
    end
  end

end
