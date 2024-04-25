# frozen_string_literal: true

class UsersController < ApplicationController
  include UserSettable

  before_action :set_action_to_user_finder, :set_action_to_user_args
  before_action except: %i[index] do
    set_user { |finder, args| finder.call(*args[:args], **args[:kwargs]) }
  end

  attr_accessor :users

  # GET /users or /users.json
  def index
    self.users = User.all
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new; end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    return render :new, status: :unprocessable_entity unless user.save

    redirect_to user, notice: 'Registration successful. Confirmation email sent.'
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    return render :edit, status: :unprocessable_entity unless user.update(user_params)

    redirect_to user, notice: 'User was successfully updated.'
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    user.destroy!

    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_action_to_user_finder
    self.action_to_user_finder = {
      show: User.method(:find),
      new: User.method(:new),
      create: User.method(:new),
      edit: User.method(:find),
      update: User.method(:find),
      destroy: User.method(:find)
    }
  end

  def set_action_to_user_args
    self.action_to_user_args = {
      show: { args: [params[:id]], kwargs: {} },
      new: { args: [], kwargs: {} },
      create: { args: [], kwargs: user_params },
      edit: { args: [params[:id]], kwargs: {} },
      update: { args: [params[:id]], kwargs: {} },
      destroy: { args: [params[:id]], kwargs: {} }
    }
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :date_of_birth, :role, :email, :phone_number,
                                 :password, :password_confirmation)
  rescue ActionController::ParameterMissing
    {}
  end
end
