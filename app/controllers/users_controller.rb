class UsersController < ApplicationController
  before_action :user
  before_action :authenticate_user!, only: [:select_friends, :send_invites]

  def show
  end

  def select_friends
    @friendships = graph.friendships
  end

  def send_invites
    graph.send_invites(params[:recipients])
    redirect_to select_friends_user_url(current_user), notice: 'Friends invites sended!'
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
