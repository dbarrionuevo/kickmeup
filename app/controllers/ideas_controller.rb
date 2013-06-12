class IdeasController < ApplicationController
  before_action :idea, only: [:show, :edit, :update, :destroy, :kickup]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @ideas = Idea.all
  end

  def show
  end

  def new
    @idea = Idea.new
  end

  def edit
  end

  def create
    @idea = Idea.new(idea_params.merge(user_id: current_user.uid))

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
    redirect_to ideas_url
  end

  def kickup
    set_user_kicked
    idea.kickup
    if idea.save
      redirect_to root_path, notice: 'Idea was successfully kicked up'
    else
      redirect_to root_path, alert: idea.errors.full_messages
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def idea
      @idea ||= Idea.find(params[:id])
    end

    def set_user_kicked
      idea.user_kicked = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idea_params
      params.require(:idea).permit(:user_id, :title, :description)
    end
end
