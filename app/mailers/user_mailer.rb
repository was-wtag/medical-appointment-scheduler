# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_confirmation_email(user_full_name, user_email, confirmation_token)
    @user_full_name = user_full_name
    @confirmation_token = confirmation_token
    mail(to: user_email, subject: 'Welcome to WellCare - Confirm Your Account')
  end
end
