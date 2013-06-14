class UsersController < ApplicationController

  def show
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Invalid User"
    end
  end

end
