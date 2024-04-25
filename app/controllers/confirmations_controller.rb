# frozen_string_literal: true

class ConfirmationsController < ApplicationController
  include UserSettable

  before_action :set_action_to_user_finder, :set_action_to_user_args
  before_action only: %i[show create] do
    set_user { |finder, args| finder.call(*args[:args], **args[:kwargs]) }
  end

  def show
    return flash.now[:alert] = 'Account confirmation failed' if user.nil?
    return flash.now[:notice] = 'Account already confirmed' if user.active?

    return unless user.pending?

    user.active!
    flash.now[:notice] = 'Account confirmation successful'
  end

  def new; end

  def create
    return redirect_to new_confirmation_url, alert: 'Account can not be confirmed' if user.nil?
    return redirect_to new_confirmation_url, alert: 'Account already confirmed' if user.active?

    return unless user.pending?

    resend_confirmation
    redirect_to new_confirmation_url, notice: 'Confirmation email sent'
  end

  private

  def resend_confirmation
    user.generate_confirmation_token
    user.send_confirmation_email
  end

  def set_action_to_user_finder
    self.action_to_user_finder = {
      show: User.method(:find_signed),
      create: User.method(:find_by_email)
    }
  end

  def set_action_to_user_args
    self.action_to_user_args = {
      show: { args: [params[:token]], kwargs: { purpose: :account_confirmation } },
      create: { args: [params[:email]], kwargs: {} }
    }
  end
end
