# frozen_string_literal: true

class AuthController < ApplicationController
  include UserSettable
  include Authenticable

  before_action lambda {
                  self.action_to_user_finder = {
                    create: User.method(:find_by_email)
                  }
                },
                lambda {
                  self.action_to_user_args = {
                    create: { args: [auth_params[:email]], kwargs: {} }
                  }
                }, :set_user, only: %i[create]

  before_action :authenticate!, only: %i[destroy]
  before_action :do_not_authenticate!, except: %i[destroy]

  def new; end

  def create
    unless user&.authenticate(auth_params[:password])
      return redirect_to new_auth_url,
                         alert: 'Invalid email or password'
    end

    return redirect_to new_auth_url, alert: 'Account not active' unless user.active?

    payload = { user_id: user.id }
    token = JwtService.encode(payload)
    cookies[:jwt] = { value: token, httponly: true }
    self.current_user = user

    redirect_to root_url, notice: 'Logged in successfully'
  end

  def destroy
    session.delete(:current_user)
    cookies.delete(:jwt)
    redirect_to new_auth_url, notice: 'Logged out successfully'
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
