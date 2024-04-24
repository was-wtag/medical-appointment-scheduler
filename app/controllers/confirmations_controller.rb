# frozen_string_literal: true

class ConfirmationsController < ApplicationController
  def show
    confirmation_token = params[:token]
    user = User.find_signed(confirmation_token, purpose: :account_confirmation)

    flash[:alert] = 'Account confirmation failed' if user.nil?
    flash[:notice] = 'Account already confirmed' if user&.active?
    flash[:notice] = 'Account confirmation successful' if user&.pending?

    user&.active!
  end

  def new; end

  def create
    user = User.find_by(email: params[:email])

    flash[:alert] = 'Account can not be confirmed' if user.nil?
    flash[:alert] = 'Account already confirmed' if user&.active?
    flash[:notice] = 'Confirmation email sent' if user&.pending?

    redirect_to new_confirmation_url
    return unless user&.pending?

    user.generate_confirmation_token
    user.send_confirmation_email
  end

  private

  def confirmation_params
    params.require(:confirmation).permit(:email)
  end
end
