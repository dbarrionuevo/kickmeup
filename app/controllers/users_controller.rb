class UsersController < ApplicationController
  before_action :user

  def show
  end

  def select_friends
    @friendships = current_user.friendships
  end

  def invite_friends
    recipients = current_user.recipients(params[:invites])
    FacebookMailer.invite_friends( current_user, recipients ).deliver
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
