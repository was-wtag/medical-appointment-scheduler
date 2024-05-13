# frozen_string_literal: true

class DoctorsController < ApplicationController
  include UserSettable
  include Authenticable

  before_action :authenticate!
  before_action lambda {
                  self.action_to_user_finder = {
                    show: User.method(:find_by)
                  }
                },
                lambda {
                  self.action_to_user_args = {
                    show: { args: [], kwargs: { role: 'doctor', id: params[:id] } }
                  }
                }, :set_user, only: %i[show]
  before_action :authorize_doctor

  attr_accessor :users

  def index
    self.users = policy_scope(User, policy_scope_class: DoctorPolicy::Scope)
  end

  def show; end

  def requests
    self.users = policy_scope(User, policy_scope_class: DoctorPolicy::Scope)
  end

  private

  def authorize_doctor
    authorize user, policy_class: DoctorPolicy
  end
end
