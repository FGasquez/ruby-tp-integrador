class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[ show edit update destroy ]

  # GET /professionals or /professionals.json
  def index
    @professionals = Professional.all
  end

  # GET /professionals/1 or /professionals/1.json
  def show
  end

  # GET /professionals/new
  def new
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
  end

  # GET /professionals/1/destroy_all_appointments/
  def destroy_all_appointments
    @professional = Professional.find(params[:id])
    @professional.appointments.destroy_all
    redirect_to professional_path
  end
  
  # GET /professionals/1/appointments
  def appointments
    @professional = Professional.find(params[:id])
    @appointments = Appointment.where(professional_id: params[:id])
  end

  # POST /professionals or /professionals.json
  def create
    authorize!
    @professional = Professional.new(professional_params)

    respond_to do |format|
      if @professional.save
        format.html { redirect_to @professional, notice: "Professional was successfully created." }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professionals/1 or /professionals/1.json
  def update
    authorize!
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to @professional, notice: "Professional was successfully updated." }
        format.json { render :show, status: :ok, location: @professional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professionals/1 or /professionals/1.json
  def destroy
    authorize!
    # get appointments for professional
    appointments = Appointment.where(professional_id: @professional.id)
    if appointments.count > 0
      # show error
      respond_to do |format|
        format.html { redirect_to professionals_url, notice: "Professional has appointments and cannot be deleted." }
        format.json { head :no_content }
      end
    else
      @professional.destroy
      respond_to do |format|
        format.html { redirect_to professionals_url, notice: "Professional was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def professional_params
      params.require(:professional).permit(:name, :surname)
    end
end
