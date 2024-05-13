# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def new?
    user.nil?
  end

  def create?
    user.nil?
  end

  def update?
    user.admin?
  end

  def confirm?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      user.admin? ? non_admin : scope.none
    end

    private

    def non_admin
      scope.where.not(role: 'admin')
    end
  end
end
