# frozen_string_literal: true

class DoctorPolicy < ApplicationPolicy
  def index?
    user.patient?
  end

  def show?
    user.patient? && record&.doctor?
  end

  def requests?
    user.admin?
  end

  class Scope < Scope
    def resolve
      case user.role
      when 'patient'
        doctors
      when 'admin'
        inactive_doctors
      else
        scope.none
      end
    end

    private

    def doctors
      scope.where(role: User.roles[:doctor])
    end

    def inactive_doctors
      doctors.where(status: User.statuses[:pending])
    end
  end
end
