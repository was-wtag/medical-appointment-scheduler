# frozen_string_literal: true

class AppointmentsController < ApplicationController
  include Authenticable

  before_action :authenticate!
  before_action :set_appointment, only: %i[show edit update destroy]
  before_action :authorize_appointment

  attr_accessor :appointments, :appointment

  # GET /appointments or /appointments.json
  def index
    self.appointments = policy_scope(Appointment, policy_scope_class: AppointmentPolicy::Scope)
  end

  # GET /appointments/1 or /appointments/1.json
  def show; end

  # GET /appointments/new
  def new
    self.appointment = Appointment.new(new_query_params)
  end

  # GET /appointments/1/edit
  def edit; end

  # POST /appointments or /appointments.json
  def create
    self.appointment = Appointment.new(patient: current_user, **appointment_params)

    return render :new, status: :unprocessable_entity unless appointment.save

    redirect_to appointment, notice: 'Appointment was successfully created.'
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    return render :edit, status: :unprocessable_entity unless appointment.update(appointment_params)

    redirect_to appointment, notice: 'Appointment was successfully updated.'
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    appointment.destroy!

    respond_to do |format|
      format.html { redirect_to appointments_url, notice: 'Appointment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    self.appointment = Appointment.find(params[:id])
  end

  def authorize_appointment
    authorize appointment, policy_class: AppointmentPolicy
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:scheduled_time, :duration_minutes, :patient_id, :doctor_id)
  end

  def new_query_params
    params.permit(:doctor_id)
  end
end
