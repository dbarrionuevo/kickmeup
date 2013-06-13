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
      render action: 'new'
    end
  end

  def update
    if idea.update(idea_params)
      redirect_to @idea, notice: 'Idea was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    idea.destroy
    redirect_to root_path, notice: "Idea was successfully destroyed."
  end

  def kickup
    set_user_kicked

    if idea.already_kicked_by_user?
      redirect_to root_path, notice: 'You already kicked this idea'
      return
    end

    if idea.kickup.save
      redirect_to root_path, notice: 'Idea was successfully kicked up'
    else
      redirect_to root_path, alert: idea.errors.full_messages
    end
  end

  private
    def idea
      @idea ||= Idea.find(params[:id])
    end

    def set_user_kicked
      idea.user_kicked = current_user
    end

    def idea_params
      params.require(:idea).permit(:user_id, :title, :description)
    end
end
