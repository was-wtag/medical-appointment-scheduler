# frozen_string_literal: true

class Appointment < ApplicationRecord
  enum status: { pending: 0, confirmed: 1, canceled: 2, completed: 3 }

  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'

  validates :scheduled_time, :status, presence: true
  validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :patient_to_be_patient, :doctor_to_be_doctor

  private

  def patient_to_be_patient
    errors.add(:patient, 'must be a patient') unless patient.patient?
  end

  def doctor_to_be_doctor
    errors.add(:doctor, 'must be a doctor') unless doctor.doctor?
  end
end
