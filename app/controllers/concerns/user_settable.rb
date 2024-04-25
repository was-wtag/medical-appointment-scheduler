# frozen_string_literal: true

module UserSettable
  extend ActiveSupport::Concern

  included do
    attr_accessor :user, :action_to_user_finder, :action_to_user_args
  end

  private

  def set_user
    finder = action_to_user_finder[action_name.to_sym]
    args = action_to_user_args[action_name.to_sym]

    self.user = finder.call(*args[:args], **args[:kwargs])
  end
end
