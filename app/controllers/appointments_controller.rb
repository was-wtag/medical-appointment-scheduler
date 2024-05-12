# frozen_string_literal: true

class AppointmentsController < ApplicationController
  include Authenticable

  before_action :authenticate!
  before_action :set_appointment, only: %i[show edit update destroy cancel confirm]
  before_action :authorize_appointment

  attr_accessor :appointments, :appointment

  # GET /appointments
  def index
    self.appointments = policy_scope(Appointment, policy_scope_class: AppointmentPolicy::Scope)
  end

  # GET /appointments/1
  def show; end

  # GET /appointments/new
  def new
    self.appointment = Appointment.new(new_query_params)
  end

  # GET /appointments/1/edit
  def edit; end

  # POST /appointments
  def create
    self.appointment = Appointment.new(patient: current_user, **appointment_params)

    return render :new, status: :unprocessable_entity unless appointment.save

    calendar_link, created_event = *event
    event_info = {
      event_id: created_event.id,
      event_link: created_event.html_link
    }
    appointment.update!(**event_info)
    send_appointment_info(calendar_link)

    redirect_to appointment, notice: 'Appointment was successfully created.'
  end

  # PATCH/PUT /appointments/1
  def update
    return render :edit, status: :unprocessable_entity unless appointment.update(appointment_params)

    calendar_link, = updated_event
    send_appointment_info(calendar_link)

    redirect_to appointment, notice: 'Appointment was successfully updated.'
  end

  def cancel
    return redirect_to appointment, alert: 'Appointment is already canceled.' if appointment.canceled?

    appointment.canceled!
    send_appointment_info

    redirect_to appointment, alert: 'Appointment was canceled.'
  end

  def confirm
    return redirect_to appointment, alert: 'Appointment is already confirmed.' if appointment.confirmed?

    appointment.confirmed!
    send_appointment_info

    redirect_to appointment, notice: 'Appointment was confirmed.'
  end

  # DELETE /appointments/1
  def destroy
    appointment.destroy!

    redirect_to appointments_url, notice: 'Appointment was successfully destroyed.'
  end

  private

  def event(event_service = EventService.new)
    event_service.share_calendar_with_attendees(appointment)
    created_event = event_service.create_event(appointment)
    calendar_link = event_service.calendar_link
    [calendar_link, created_event]
  end

  def updated_event(event_service = EventService.new)
    updated_event = event_service.update_event(appointment)
    calendar_link = event_service.calendar_link
    [calendar_link, updated_event]
  end

  def send_appointment_info(calendar_link = nil)
    case action_name
    when 'create'
      UserMailer.send_appointment_emails(appointment, calendar_link).deliver_now
    when 'update'
      UserMailer.send_appointment_reschedule_email(appointment, calendar_link).deliver_now
    when 'confirm'
      UserMailer.send_appointment_confirmation_email(appointment).deliver_now
    when 'cancel'
      for_ = current_user.patient? ? :doctor : :patient
      UserMailer.send_appointment_cancellation_email(appointment, for_).deliver_now
    else
      raise ArgumentError, 'Invalid action'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    self.appointment = Appointment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to appointments_url, alert: 'Appointment not found.'
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
