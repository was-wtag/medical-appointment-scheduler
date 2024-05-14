# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_confirmation_email(user_full_name, user_email, confirmation_token)
    @user_full_name = user_full_name
    @confirmation_token = confirmation_token
    mail(to: user_email, subject: 'Welcome to WellCare - Confirm Your Account')
  end
  
  def send_verification_email(user_full_name, user_email, verification_token)
    @user_full_name = user_full_name
    @verification_token = verification_token
    mail(to: user_email, subject: 'WellCare Password Reset - Verify Your Email')
  end
  
  def send_confirmation_by_admin_email(doctor_full_name, doctor_email)
    @doctor_full_name = doctor_full_name
    mail(to: doctor_email, subject: 'Welcome to WellCare - Confirm Your Account')
  end

  def send_appointment_emails(appointment, calendar_link)
    @appointment = appointment
    @calendar_link = calendar_link
    mail(**appointment_email_params(@appointment, :patient))
    mail(**appointment_email_params(@appointment, :doctor))
  end

  def send_appointment_reschedule_email(appointment, calendar_link)
    @appointment = appointment
    @calendar_link = calendar_link
    mail(to: appointment.doctor.email, subject: "Appointment Reschedule with #{appointment.patient.full_name}")
  end

  def send_appointment_confirmation_email(appointment)
    @appointment = appointment
    mail(to: appointment.patient.email, subject: "Appointment Confirmation with Dr. #{appointment.doctor.full_name}")
  end

  def send_appointment_cancellation_email(appointment, for_)
    @appointment = appointment
    mail(**appointment_cancellation_email_params(appointment, for_))
  end

  private

  def appointment_email_params(appointment, for_)
    case for_
    when :patient
      {
        to: appointment.patient.email,
        subject: "Appointment Confirmation with Dr. #{appointment.doctor.full_name}",
        template_path: 'user_mailer',
        template_name: 'send_appointment_email_to_patient'
      }
    when :doctor
      {
        to: appointment.doctor.email,
        subject: "Appointment Confirmation with #{appointment.patient.full_name}",
        template_path: 'user_mailer',
        template_name: 'send_appointment_email_to_doctor'
      }
    else
      raise ArgumentError, 'Invalid recipient'
    end
  end

  def appointment_cancellation_email_params(appointment, for_)
    case for_
    when :patient
      {
        to: appointment.patient.email,
        subject: "Appointment Cancellation with Dr. #{appointment.doctor.full_name}",
        template_path: 'user_mailer',
        template_name: 'send_appointment_cancellation_email_to_patient'
      }
    when :doctor
      {
        to: appointment.doctor.email,
        subject: "Appointment Cancellation with #{appointment.patient.full_name}",
        template_path: 'user_mailer',
        template_name: 'send_appointment_cancellation_email_to_doctor'
      }
    else
      raise ArgumentError, 'Invalid recipient'
    end
  end
end
