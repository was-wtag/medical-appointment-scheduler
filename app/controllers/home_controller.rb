# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def login
    redirect_to new_auth_url
  end

  def signup
    redirect_to new_user_url
  end
end
