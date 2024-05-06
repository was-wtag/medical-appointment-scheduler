# frozen_string_literal: true

class DoctorPolicy < ApplicationPolicy
  def index?
    user.patient?
  end

  def show?
    user.patient? && record&.doctor?
  end

  class Scope < Scope
    def resolve
      # user.patient? ? doctors : scope.none
      doctors
    end

    private

    def doctors
      scope.where(role: 'doctor')
    end
  end
end
