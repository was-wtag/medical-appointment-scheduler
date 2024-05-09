# frozen_string_literal: true

class Appointment < ApplicationRecord
  enum status: { pending: 0, confirmed: 1, canceled: 2, completed: 3 }

  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'

  validates :scheduled_time, :status, presence: true
  validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :patient_to_be_patient, if: -> { patient.present? }
  validate :doctor_to_be_doctor, if: -> { doctor.present? }
  validate :scheduled_in_future, :scheduled_time_does_not_clash, if: lambda {
                                                                       scheduled_time.present?\
                                                                         && duration_minutes.present?
                                                                     }

  def end_time
    scheduled_time + duration_minutes.minutes
  end

  def title
    "#{patient.full_name}'s Appointment with Dr. #{doctor.full_name}"
  end

  private

  def patient_to_be_patient
    errors.add(:patient, 'must be a patient') unless patient.patient?
  end

  def doctor_to_be_doctor
    errors.add(:doctor, 'must be a doctor') unless doctor.doctor?
  end

  def scheduled_in_future
    errors.add(:scheduled_time, 'must be in the future') unless scheduled_time.future?
  end

  def scheduled_time_does_not_clash
    overlapping_appointments = Appointment.where.not(id:)
                                          .where.not(status: :canceled)
                                          .where('doctor_id = ? OR patient_id = ?', doctor.id, patient.id)
                                          .where("(scheduled_time BETWEEN ? AND ?) OR ((scheduled_time + ? * INTERVAL '1 minute') BETWEEN ? AND ?)",
                                                 scheduled_time, end_time, duration_minutes, scheduled_time, end_time)
    return unless overlapping_appointments.exists?

    errors.add(:scheduled_time, 'clashes with another appointment')
  end
end
