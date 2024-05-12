# frozen_string_literal: true

class UpdateAppointmentStatusJob < ApplicationJob
  queue_as :default
  discard_on ActiveJob::DeserializationError

  def perform
    Appointment
      .where("scheduled_time + ? * INTERVAL '1 minute' < ? AND status = ?", duration_minutes, Time.current, :confirmed)
      .update_all(status: :completed)
  end
end
