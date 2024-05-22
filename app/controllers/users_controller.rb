# frozen_string_literal: true

class UsersController < ApplicationController
  include UserSettable
  include Authenticable

  before_action :set_action_to_user_finder, :set_action_to_user_args
  before_action except: %i[index] do
    set_user { |finder, args| finder.call(*args[:args], **args[:kwargs]) }
  end
  before_action -> { redirect_back fallback_location: root_url, alert: 'User Not Found.' if user.nil? },
                except: %i[index new create]

  before_action :authenticate!, except: %i[new create]
  before_action :do_not_authenticate!, only: %i[new create]
  before_action :authorize_user

  before_action -> { self.profile_to_model = { 'patient' => PatientProfile, 'doctor' => DoctorProfile } },
                only: %i[show create]
  before_action -> { self.profile_partial = user.doctor? ? 'doctor_profile' : 'patient_profile' }, only: %i[show]

  attr_accessor :users, :profile, :profile_to_model, :profile_partial

  # GET /users or /users.json
  def index
    self.users = policy_scope(User, policy_scope_class: UserPolicy::Scope)
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new; end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    return render :new, status: :unprocessable_entity unless save_user_and_profile

    redirect_to user, notice: 'Registration successful. Confirmation email sent.'
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    ActiveRecord::Base.transaction do
      user.avatar.purge if purge_avatar?

      unless user.update(user_params)
        render :edit, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end

    redirect_to edit_profile_url, notice: 'User was successfully updated.'
  end

  def confirm
    return redirect_to user, alert: 'User is already confirmed.' if user.active?

    user.active!
    user.send_confirmation_by_admin_email if user.doctor?

    redirect_to user, notice: 'User was successfully confirmed.'
  end

  def pending
    return redirect_to user, alert: 'User is already pending.' if user.pending?

    user.pending!

    redirect_to user, notice: 'User was successfully set as pending.'
  end

  def delete
    return redirect_to user, alert: 'User is already deleted.' if user.deleted?

    user.deleted!

    redirect_to user, notice: 'User was successfully set as deleted.'
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    user.destroy!

    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def save_user_and_profile
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless user.save

      profile_model = profile_to_model[user.role]
      self.profile = profile_model.new(profile_params)
      profile.user = user

      raise ActiveRecord::Rollback unless profile.save
    end

    user.errors.empty? && profile.errors.empty?
  end

  def set_action_to_user_finder
    self.action_to_user_finder = {
      show: User.method(:find),
      new: User.method(:new),
      create: User.method(:new),
      edit: User.method(:find),
      update: User.method(:find),
      destroy: User.method(:find),
      confirm: User.method(:find),
      pending: User.method(:find),
      delete: User.method(:find)
    }
  end

  def set_action_to_user_args
    self.action_to_user_args = {
      show: { args: [params[:id]], kwargs: {} },
      new: { args: [], kwargs: {} },
      create: { args: [], kwargs: user_params },
      edit: { args: [params[:id]], kwargs: {} },
      update: { args: [params[:id]], kwargs: {} },
      destroy: { args: [params[:id]], kwargs: {} },
      confirm: { args: [params[:id]], kwargs: {} },
      pending: { args: [params[:id]], kwargs: {} },
      delete: { args: [params[:id]], kwargs: {} }
    }
  end

  def authorize_user
    authorize user, policy_class: UserPolicy
  end

  # Only allow a list of trusted parameters through.
  def user_params
    if action_name == 'create'
      params.require('[user]').permit(:first_name, :last_name, :avatar, :gender, :date_of_birth, :role, :email,
                                      :phone_number, :password, :password_confirmation)
    else
      params.require(:user).permit(:status)
    end

    case action_name
    when 'create'
      params.require('[user]').permit(:first_name, :last_name, :avatar, :gender, :date_of_birth, :role, :email,
                                      :phone_number, :password, :password_confirmation)
    when 'update'
      params.require(:user).permit(:first_name, :last_name, :avatar, :gender, :date_of_birth, :phone_number)
    else
      params.require(:user).permit(:status)
    end
  rescue ActionController::ParameterMissing
    {}
  end

  def profile_params
    if user.doctor?
      params.require('[doctor_profile]').permit(:specialty, :registration_number, :chamber_address)
    elsif user.patient?
      params.require('[patient_profile]').permit(:blood_group, :height_cm, :weight_kg, :nid_number, :medical_history)
    else
      {}
    end
  end

  def avatar_params
    params.require(:user).permit(:avatar, :purge)
  end

  def purge_avatar?
    avatar, purge = avatar_params.values_at(:avatar, :purge)
    avatar.nil? && purge == '1'
  end
end
