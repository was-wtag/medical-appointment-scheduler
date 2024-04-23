# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def login; end

  def signup
    redirect_to new_user_url
  end
end
