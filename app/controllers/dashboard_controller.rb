# frozen_string_literal: true

class DashboardController < ApplicationController
  include Authenticable

  before_action :authenticate!
  before_action :authorize_dashboard

  attr_accessor :users, :doctors, :appointments

  def show
    # Possible Refactor to use single db query
    self.users = policy_scope(User, policy_scope_class: UserPolicy::Scope)
    self.doctors = policy_scope(User, policy_scope_class: DoctorPolicy::Scope)
    self.appointments = policy_scope(Appointment, policy_scope_class: AppointmentPolicy::Scope)
    ##########################################
  end

  private

  def authorize_dashboard
    authorize :dummy, policy_class: DashboardPolicy
  end
end
