class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show, :edit, :update, :destroy]
  before_action :permisos, only: [:show, :edit, :update, :destroy, :index]
  
  # GET /competitions
  # GET /competitions.json
  def index
    user = current_user
    puts "---->ID usario #{user.id}."
    @competitions = Competition.where("users_id = ?", user.id).paginate(:page => params[:page], :per_page => 50)
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
    puts "---->ID #{params[:id]}."
    @competition = Competition.find(params[:id])
    puts "---->Name #{@competition.name}."
    puts "--->URL:#{request.protocol}#{request.host_with_port}"
    @competitors = Competitor.where("competitions_id = ?",@competition.id).order(:date_admission => :desc).paginate(:page => params[:page], :per_page => 50)
    @competition.url = "#{request.protocol}#{request.host_with_port}/#{@competition.url}"
    puts "---->competitors #{@competition.url}"
  end

  # GET /competitions/new
  def new
    user = current_user
    @competition = Competition.new
    @competition.users_id = user.id
    puts "--->Usuario logeado #{@competition.users_id}"
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions
  # POST /competitions.json
  def create
    user = current_user
    puts "--->Create"
    @competition = Competition.new(competition_params)
    @competition.users_id = user.id
    puts "--->Usuario logeado #{@competition.users_id}"
    respond_to do |format|
      if @competition.save
        format.html { redirect_to @competition, notice: 'Competition was successfully created.' }
        format.json { render :show, status: :created, location: @competition }
      else
        format.html { render :new }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitions/1
  # PATCH/PUT /competitions/1.json
  def update
    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to competitions_url, notice: 'El concurso fue actualizado.' }
        format.json { render :show, status: :ok, location: @competition }
      else
        format.html { render :edit }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitions/1
  # DELETE /competitions/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: 'El concurso fue borrado.' }
      format.json { head :no_content }
    end
    @competition = Competition.find(params[:id]).destroy
    
    puts "--->id concurso #{@competition.id}"
    
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_competition
    #@competition = Competition.find_by(url: params[:id])
    @competition = Competition.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def competition_params
    params.require(:competition).permit(:users_id, :name, :url, :start_date, :end_date, :prize, :banner)
  end
  
  def permisos
    if(!logged_in?)
      redirect_to login_path
    end
  end
end
