# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  private

  def authenticate!
    return unless current_user.nil?

    token = cookies[:jwt]
    user_id = JwtService.decode(token)['user_id']
    self.current_user = User.find(user_id)
  rescue JWT::DecodeError || JWT::ExpiredSignature
    redirect_to new_auth_url, alert: 'You must be logged in to access this page'
  end

  def do_not_authenticate!
    redirect_to root_url if current_user.present? || cookies.key?(:jwt)
  end

  def current_user
    session[:current_user]
  end

  def current_user=(user)
    session[:current_user] = user
  end
end
