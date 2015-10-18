class CompetitorsController < ApplicationController
  before_action :set_competitor, only: [:show, :edit, :update, :destroy]
  before_action :permisos, only: [:show, :edit, :update, :destroy, :index]

  # GET /competitors
  # GET /competitors.json
  def index
    @competition = Competition.find(params[:competition_id])
    @competitors = @competition.competitors.all
  end

  # GET /competitors/1
  # GET /competitors/1.json
  def show
    @competitor = Competitor.find(params[:id])
  end

  # GET /competitors/new
  def new
    @competition = Competition.find(params[:competition_id])
    @competitor = Competitor.new
  end

  # GET /competitors/1/edit
  def edit
  end

  # POST /competitors
  # POST /competitors.json
  def create
    #@competition = Competition.find(params[:competition_id])
    @competitor = Competitor.new(competitor_params)
    @competitor.status_video = 'En Proceso'
    #@competitor.competitions_id = params[:competition_id]
    @competitor.date_admission = Time.now.getutc
    respond_to do |format|
      if @competitor.save
        @competition = Competition.find(@competitor.competitions_id)
        format.html { redirect_to "/" + @competition.url, notice: 'Hemos Recibido Tu Video. Te Enviaremos un Correo Electronico Cuando el Video Este Disponible!' }
        format.json { render :show, status: :created, location: @competitor }
      else
        format.html { render :new }
        format.json { render json: @competitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitors/1
  # PATCH/PUT /competitors/1.json
  def update
    respond_to do |format|
      if @competitor.update(competitor_params)
        format.html { redirect_to @competitor, notice: 'Competitor was successfully updated.' }
        format.json { render :show, status: :ok, location: @competitor }
      else
        format.html { render :edit }
        format.json { render json: @competitor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitors/1
  # DELETE /competitors/1.json
  def destroy
    @competitor.destroy
    respond_to do |format|
      format.html { redirect_to competitors_url, notice: 'Competitor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_competitor
    @competitor = Competitor.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def competitor_params
    params.require(:competitor).permit(:competitions_id, :first_name, :second_name, :last_name, :second_last_name, :date_admission, :email, :message, :status_video, :video_original, :video_converted)
  end
  def permisos
    if(!logged_in?)
      redirect_to login_path
    end
  end
end
