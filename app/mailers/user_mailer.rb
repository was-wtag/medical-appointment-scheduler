# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to WellCare - Confirm Your Account')
  end
end
