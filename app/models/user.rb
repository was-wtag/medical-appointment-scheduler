# frozen_string_literal: true

class User < ApplicationRecord
  PASSWORD_RESET_TOKEN_EXPIRES_IN = 5.minutes

  enum role: { admin: 0, doctor: 1, patient: 2 }
  enum gender: { not_specified: 0, female: 1, male: 2 }
  enum status: { pending: 0, active: 1, deleted: 2 }

  after_create :generate_confirmation_token, if: -> { pending? }

  attr_accessor :confirmation_token, :password_reset_token

  has_secure_password

  has_one_attached :avatar

  has_one :doctor_profile, dependent: :destroy
  has_one :patient_profile, dependent: :destroy
  has_many :doctor_appointments, class_name: 'Appointment', foreign_key: 'doctor_id', dependent: :destroy
  has_many :patient_appointments, class_name: 'Appointment', foreign_key: 'patient_id', dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 128 }
  validates :last_name, presence: true, length: { maximum: 128 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :phone_number, presence: true, uniqueness: true,
                           format: { with: /\A\+?[0-9]{1,3}-?[0-9]{1,14}\z/, allow_blank: true }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || password.present? }
  validates :password_confirmation, presence: true, if: -> { new_record? || password.present? }
  validate :avatar_to_be_within_size, :avatar_to_be_image

  def generate_confirmation_token
    self.confirmation_token = signed_id expires_in: ENV.fetch('CONFIRMATION_TOKEN_EXPIRES_IN', 5.minutes),
                                        purpose: :account_confirmation
  end

  def generate_password_reset_token
    self.password_reset_token = signed_id expires_in: PASSWORD_RESET_TOKEN_EXPIRES_IN,
                                          purpose: :password_reset
  end

  def send_confirmation_email
    UserMailer.send_confirmation_email(full_name, email, confirmation_token).deliver_later
  end

  def send_confirmation_by_admin_email
    UserMailer.send_confirmation_by_admin_email(full_name, email).deliver_later
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def profile
    doctor_profile || patient_profile
  end

  def self.doctors
    where(role: :doctor)
  end

  def self.patients
    where(role: :patient)
  end

  private

  def avatar_to_be_within_size
    return unless avatar.attached?

    return unless avatar.blob.byte_size > 300.kilobytes

    avatar.purge
    errors.add(:avatar, 'is too big')
  end

  def avatar_to_be_image
    return unless avatar.attached?

    return if avatar.blob.content_type.starts_with?('image/')

    avatar.purge
    errors.add(:avatar, 'is not an image')
  end
end
