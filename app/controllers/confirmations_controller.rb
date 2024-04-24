# frozen_string_literal: true

class ConfirmationsController < ApplicationController
  before_action :set_action_to_user_finder, :set_action_to_user_args, only: %i[show create]
  before_action only: %i[show create] do
    set_user { |finder, args| finder.call(*args[:args], **args[:kwargs]) }
  end

  def show
    return flash[:alert] = 'Account confirmation failed' if @user.nil?
    return flash[:notice] = 'Account already confirmed' if @user.active?

    return unless @user.pending?

    @user.active!
    flash[:notice] = 'Account confirmation successful'
  end

  def new; end

  def create
    return redirect_to_new_confirmation('Account can not be confirmed', :alert) if @user.nil?
    return redirect_to_new_confirmation('Account already confirmed', :alert) if @user.active?

    return unless @user.pending?

    resend_confirmation
    redirect_to_new_confirmation('Confirmation email sent', :notice)
  end

  private

  def resend_confirmation
    @user.generate_confirmation_token
    @user.send_confirmation_email
    flash[:notice] = 'Confirmation email sent'
  end

  def redirect_to_new_confirmation(message, type)
    flash[type] = message
    redirect_to new_confirmation_url
  end

  def set_user
    finder = @action_to_user_finder[action_name.to_sym]
    args = @action_to_user_args[action_name.to_sym]

    @user = yield(finder, args)
  end

  def set_action_to_user_finder
    @action_to_user_finder = {
      show: User.method(:find_signed),
      create: User.method(:find_by)
    }
  end

  def set_action_to_user_args
    @action_to_user_args = {
      show: { args: [params[:token]], kwargs: { purpose: :account_confirmation } },
      create: { args: [], kwargs: { email: params[:email] } }
    }
  end
end
