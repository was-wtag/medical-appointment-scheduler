# frozen_string_literal: true

class ProfileController < ApplicationController
  include Authenticable

  before_action :authenticate!
  before_action -> { self.current_profile = current_user.profile }
  before_action -> { self.current_profile_partial = current_user.doctor? ? 'doctor_profile' : 'patient_profile' }

  attr_accessor :current_profile, :current_profile_partial

  def show; end

  def edit; end

  def update
    return render :edit, status: :unprocessable_entity unless current_profile.update(profile_params)

    redirect_to edit_profile_url, notice: 'Profile was successfully updated.'
  end

  private

  def profile_params
    if current_user.doctor?
      params.require(:doctor_profile).permit(:specialization, :description)
    elsif current_user.patient?
      params.require(:patient_profile).permit(:blood_group, :height_cm, :weight_kg, :medical_history)
    else
      {}
    end
  end
end
