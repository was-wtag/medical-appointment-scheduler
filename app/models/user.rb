# frozen_string_literal: true

class User < ApplicationRecord
  enum role: { admin: 0, doctor: 1, patient: 2 }
  enum gender: { not_specified: 0, female: 1, male: 2 }
  enum status: { pending: 0, active: 1, deleted: 2 }

  after_create :generate_confirmation_token, if: -> { pending? }
  after_create :send_confirmation_email, if: -> { pending? && confirmation_token.present? }

  attr_reader :confirmation_token

  has_secure_password

  validates :first_name, presence: true, length: { maximum: 128 }
  validates :last_name, presence: true, length: { maximum: 128 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A\+?[0-9]{1,3}-?[0-9]{1,14}\z/ }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || password.present? }

  def generate_confirmation_token
    self.confirmation_token = signed_id expires_in: ENV.fetch('CONFIRMATION_TOKEN_EXPIRES_IN', 5.minutes),
                                        purpose: :account_confirmation
  end

  def send_confirmation_email
    UserMailer.send_confirmation_email(self).deliver_now
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  attr_writer :confirmation_token
end
