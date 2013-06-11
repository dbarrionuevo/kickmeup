class KickedIdeasController < ApplicationController
  before_action :set_kicked_idea, only: [:show, :edit, :update, :destroy]

  # GET /kicked_ideas
  # GET /kicked_ideas.json
  def index
    @kicked_ideas = KickedIdea.all
  end

  # GET /kicked_ideas/1
  # GET /kicked_ideas/1.json
  def show
  end

  # GET /kicked_ideas/new
  def new
    @kicked_idea = KickedIdea.new
  end

  # GET /kicked_ideas/1/edit
  def edit
  end

  # POST /kicked_ideas
  # POST /kicked_ideas.json
  def create
    @kicked_idea = KickedIdea.new(kicked_idea_params)

    respond_to do |format|
      if @kicked_idea.save
        format.html { redirect_to @kicked_idea, notice: 'Kicked idea was successfully created.' }
        format.json { render action: 'show', status: :created, location: @kicked_idea }
      else
        format.html { render action: 'new' }
        format.json { render json: @kicked_idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kicked_ideas/1
  # PATCH/PUT /kicked_ideas/1.json
  def update
    respond_to do |format|
      if @kicked_idea.update(kicked_idea_params)
        format.html { redirect_to @kicked_idea, notice: 'Kicked idea was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @kicked_idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kicked_ideas/1
  # DELETE /kicked_ideas/1.json
  def destroy
    @kicked_idea.destroy
    respond_to do |format|
      format.html { redirect_to kicked_ideas_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kicked_idea
      @kicked_idea = KickedIdea.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kicked_idea_params
      params.require(:kicked_idea).permit(:user_id)
    end
end
