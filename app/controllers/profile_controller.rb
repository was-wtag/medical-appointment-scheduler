# frozen_string_literal: true

class ProfileController < ApplicationController
  include Authenticable

  before_action :authenticate!
  before_action -> { self.current_profile = current_user.profile }
  before_action -> { self.current_profile_partial = current_user.doctor? ? 'doctor_profile' : 'patient_profile' }

  attr_accessor :current_profile, :current_profile_partial

  def show; end

  def edit; end

  def update; end
end
