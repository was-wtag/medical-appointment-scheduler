# frozen_string_literal: true

class UpdateAppointmentStatusJob < ApplicationJob
  queue_as :default
  discard_on ActiveJob::DeserializationError

  def perform
    Appointment
      .where("scheduled_time + duration_minutes * INTERVAL '1 minute' < ? AND status = ?",
             Time.current, Appointment.statuses[:confirmed])
      .update_all(status: Appointment.statuses[:completed])
  end
end
