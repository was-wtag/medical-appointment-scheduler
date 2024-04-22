# frozen_string_literal: true

class User < ApplicationRecord
  enum role: { admin: 0, doctor: 1, patient: 2 }
  enum gender: { not_specified: 0, female: 1, male: 2 }

  has_secure_password

  validates :first_name, presence: true, length: { maximum: 128 }
  validates :last_name, presence: true, length: { maximum: 128 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true, uniqueness: true, format: { with: /\A\+?[0-9]{1,3}-?[0-9]{1,14}\z/ }
  validates :password, length: { minimum: 8 }
end
