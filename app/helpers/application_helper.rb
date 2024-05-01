# frozen_string_literal: true

module ApplicationHelper
  def current_user
    controller.current_user if controller.respond_to?(:current_user)
  end
end
