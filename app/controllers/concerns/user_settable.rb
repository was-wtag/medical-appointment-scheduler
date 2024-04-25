# frozen_string_literal: true

module UserSettable
  extend ActiveSupport::Concern

  private

  def set_user
    finder = @action_to_user_finder[action_name.to_sym]
    args = @action_to_user_args[action_name.to_sym]

    @user = finder.call(*args[:args], **args[:kwargs])
  end
end
