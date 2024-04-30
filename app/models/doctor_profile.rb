# frozen_string_literal: true

class DoctorProfile < ApplicationRecord
  enum specialty: { general: 0, pediatric: 1, gynecologist: 2, orthopedic: 3, cardiologist: 4, dermatologist: 5,
                    neurologist: 6, psychiatrist: 7, dentist: 8, ophthalmologist: 9, oncologist: 10, urologist: 11,
                    endocrinologist: 12, gastroenterologist: 13, pulmonologist: 14, rheumatologist: 15,
                    nephrologist: 16, hematologist: 17, allergist: 18, geriatrician: 19, radiologist: 20,
                    anesthesiologist: 21, surgeon: 22, other: 23 }

  belongs_to :user

  validates :specialty, :chamber_address, presence: true
  validates :registration_number, :user, presence: true, uniqueness: true
  validate :user_to_be_a_doctor, :user_not_to_have_a_patient_profile

  private

  def user_to_be_a_doctor
    errors.add(:user, 'is not a doctor') unless user.doctor?
  end

  def user_not_to_have_a_patient_profile
    errors.add(:user, 'already has a patient profile') if user.patient_profile.present?
  end

end
