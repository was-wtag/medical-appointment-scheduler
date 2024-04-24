# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    return render :new, status: :unprocessable_entity unless @user.save

    redirect_to @user, notice: 'Registration successful. Confirmation email sent.'
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    return render :edit, status: :unprocessable_entity unless @user.update(user_params)

    redirect_to @user, notice: 'User was successfully updated.'
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :gender, :date_of_birth, :role, :email, :phone_number,
                                 :password, :password_confirmation)
  end
end
