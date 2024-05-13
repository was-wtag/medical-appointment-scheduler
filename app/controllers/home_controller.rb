# frozen_string_literal: true

class HomeController < ApplicationController
  include UserSettable

  def index
    return unless cookies[:jwt]

    set_action_to_user_finder
    set_action_to_user_args
    set_user

    redirect_to user.admin? ? dashboard_url : profile_url
  end

  def login
    redirect_to new_auth_url
  end

  def signup
    redirect_to new_user_url
  end

  private

  def set_action_to_user_finder
    self.action_to_user_finder = {
      index: User.method(:find)
    }
  end

  def set_action_to_user_args
    token = cookies[:jwt]

    begin
      user_id = JwtService.decode(token)['user_id']
    rescue JWT::DecodeError || JWT::ExpiredSignature
      cookies.delete(:jwt)
      return redirect_to root_url, alert: 'Invalid Token.'
    end

    self.action_to_user_args = {
      index: { args: [user_id], kwargs: {} }
    }
  end
end
