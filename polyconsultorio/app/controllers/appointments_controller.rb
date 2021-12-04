class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]

  # GET /appointments or /appointments.json
  def index
    @appointments = Appointment.all
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    authorize!
    @appointment = Appointment.new
  end

  # GET /appointments/1/edit
  def edit
    authorize!
  end

  # GET /appointments/cancell_all/1
  def cancel_all
    #get all appointments for professional_id
    @appointments = Appointment.where(professional_id: params[:id])
    #delete all appointments
    @appointments.each do |appointment|
      appointment.destroy
    end
    # redirect to prefessionals index
    
  end

  # GET /appointments/export_form
  def export_form
  end

  # POST /appointments/export
  def export
    @professional_id = params[:professional_id]
    @week = params[:week]
    @date = params[:day]

    days = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"]
    if @week.eql? "1" then
      initial_date = (Date.parse(@date) - Date.parse(@date).wday)
      end_date = initial_date + 6
      from_date = initial_date..end_date
    else
      from_date = Date.parse(@date) .. Date.parse(@date) + 1
    end

    # get all appointments for the week and professional
    if @professional_id.eql?("-1") then
      appointments = Appointment.where(date: from_date)
    else
      appointments = Appointment.where(professional_id: @professional_id, date: from_date)
    end

    content = ERB.new(File.read('app/templates/exports.html.erb')).result_with_hash(
        { appointments: appointments, days: days, first_day: (Date.parse(@date) - Date.parse(@date).wday)})

    send_data content, filename: "appointments.html"

  end


  # POST /appointments or /appointments.json
  def create
    authorize!
    @appointment = Appointment.new(appointment_params)

    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    authorize!
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to @appointment, notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    authorize!
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url, notice: "Appointment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:name, :surname, :date, :phone, :notes, :professional_id)
    end
end
