# frozen_string_literal: true

class HomeController < ApplicationController
  include UserSettable

  before_action lambda {
                  self.action_to_user_finder = {
                    index: User.method(:find)
                  }
                },
                lambda {
                  token = cookies[:jwt]
                  user_id = JwtService.decode(token)['user_id']
                  self.action_to_user_args = {
                    index: { args: [user_id], kwargs: {} }
                  }
                }, :set_user, only: %i[index]

  def index
    return unless cookies.key?(:jwt)

    redirect_to user.admin? ? dashboard_url : profile_url
  end

  def login
    redirect_to new_auth_url
  end

  def signup
    redirect_to new_user_url
  end
end
