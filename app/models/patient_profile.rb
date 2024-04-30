# frozen_string_literal: true

class PatientProfile < ApplicationRecord
  enum blood_group: { not_specified: 0, a_positive: 1, a_negative: 2, b_positive: 3, b_negative: 4, ab_positive: 5,
                      ab_negative: 6, o_positive: 7, o_negative: 8 }

  belongs_to :user

  validates :blood_group, presence: true
  validates :height_cm, :weight_kg, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :nid_number, presence: true, uniqueness: true, format: { with: /\A[0-9]{10,17}\z/, allow_blank: true }
  validate :user_to_be_a_patient
  # validates :user, presence: true, uniqueness: true
  #
  # private
  #
  # def user_does_not_have_a_doctor_profile
  #   errors.add(:user, 'already has a doctor profile') if user.doctor_profile.present?
  # end

  private

  def user_to_be_a_patient
    errors.add(:user, 'is not a patient') unless user.patient?
  end
end
