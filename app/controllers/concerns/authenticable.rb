# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_user
  end

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
end
