# frozen_string_literal: true

class ProfilePolicy < ApplicationPolicy
  def show?
    !user.admin?
  end

  def update?
    !user.admin?
  end

  def edit?
    !user.admin?
  end
end
