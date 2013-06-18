class IdeasController < ApplicationController
  before_action :idea, only: [:show, :edit, :update, :destroy, :kickup]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @ideas = Idea.all
  end

  def show
    @idea_kickups = idea.idea_kickups
  end

  def new
    @idea = Idea.new
  end

  def edit
  end

  def create
    @idea = current_user.ideas.new(idea_params)

    if idea.save
      redirect_to @idea, notice: 'Idea was successfully created.'
    else
      render :new
    end
  end

  def update
    if idea.update(idea_params)
      redirect_to @idea, notice: 'Idea was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    idea.destroy
    redirect_to root_path, notice: "Idea was successfully destroyed."
  end

  def kickup
    set_user_kicked

    if idea.already_kicked_by_user?
      redirect_to idea_url, alert: 'You already kicked this idea'
      return
    end

    if current_user.author_of? idea
      redirect_to idea_url, alert: "Sorry, you can't kickup your own idea"
      return
    end

    if idea.kickup.save
      #current_user.facebook.put_wall_post("I kicked up this idea at kickmeup: #{idea.title}")
      redirect_to idea_url, notice: 'Idea was successfully kicked up'
    else
      redirect_to idea_url, alert: idea.errors.full_messages
    end
  end

  private
    def idea
      begin
        @idea ||= Idea.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to root_url, alert: "Idea not found!"
      end
    end
    helper_method :idea

    def set_user_kicked
      idea.user_kicked = current_user
    end

    def idea_params
      params.require(:idea).permit(:user_id, :title, :description)
    end
end
