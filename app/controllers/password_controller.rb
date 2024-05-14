# frozen_string_literal: true

class PasswordController < ApplicationController
  include UserSettable
  include Authenticable

  before_action :authenticate!, only: %i[new create]
  before_action :do_not_authenticate!, only: %i[show reset_create verify_new verify_create]
  before_action lambda {
                  self.action_to_user_finder = {
                    new: method(:current_user),
                    show: User.method(:find_signed),
                    create: method(:current_user),
                    reset_create: User.method(:find_signed),
                    verify_create: User.method(:find_by_email)
                  }
                },
                lambda {
                  self.action_to_user_args = {
                    new: { args: [], kwargs: {} },
                    show: { args: [params[:token]], kwargs: { purpose: :password_reset } },
                    create: { args: [], kwargs: {} },
                    reset_create: { args: [params[:token]], kwargs: { purpose: :password_reset } },
                    verify_create: { args: [params[:email]], kwargs: {} }
                  }
                }, :set_user, only: %i[new show create reset_create verify_create]

  attr_accessor :verification_token

  def new
    render :change_password
  end

  def show
    return redirect_to verify_url, alert: 'Invalid verification token' if user.nil?
    return redirect_to new_confirmation_url, alert: 'Please activate your account first' unless user.active?

    self.verification_token = params[:token]
    render :reset_password
  end

  def create
    password_change_params = self.password_change_params
    current_password = password_change_params[:current_password]
    passwords = {
      password: password_change_params[:new_password],
      password_confirmation: password_change_params[:new_password_confirmation]
    }

    return redirect_to new_password_url, alert: 'Invalid current password' unless user&.authenticate(current_password)
    return render :change_password, status: :unprocessable_entity unless user.update(passwords)

    redirect_to root_url, notice: 'Password changed successfully'
  end

  def reset_create
    return redirect_to verify_url, alert: 'Invalid verification token' if user.nil?
    return redirect_to new_confirmation_url, alert: 'Please activate your account first' unless user.active?

    passwords = {
      password: password_reset_params[:new_password],
      password_confirmation: password_reset_params[:new_password_confirmation]
    }
    self.verification_token = params[:token]
    return render :reset_password, status: :unprocessable_entity unless user.update(passwords)

    redirect_to home_login_url, notice: 'Password reset successful'
  end

  def verify_new; end

  def verify_create
    return redirect_to verify_url, alert: 'Invalid email address' if user.nil?
    return redirect_to verify_url, alert: 'Please activate your account first' unless user.active?

    send_verification_email
    redirect_to new_confirmation_url, notice: 'Verification email sent'
  end

  private

  def send_verification_email
    user.generate_password_reset_token
    user.send_verification_email
  end

  def password_change_params
    params.require(:user).permit(:current_password, :new_password, :new_password_confirmation)
  end

  def password_reset_params
    params.require(:user).permit(:new_password, :new_password_confirmation)
  end
end
