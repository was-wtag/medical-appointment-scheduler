# frozen_string_literal: true

class AppointmentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    case user.admin?
    when true
      true
    when false
      user.doctor? ? record.doctor == user : record.patient == user
    else
      false
    end
  end

  def new?
    user.patient?
  end

  def create?
    user.patient?
  end

  def edit?
    user.patient? && record.pending?
  end

  def update?
    user.patient? && record.pending?
  end

  def destroy?
    user.patient? && record.pending?
  end

  def permitted_attributes
    %i[scheduled_time duration_minutes doctor_id]
  end

  class Scope < Scope
    def resolve
      case user.admin?
      when true
        scope.all
      when false
        user.doctor? ? user.doctor_appointments : user.patient_appointments
      else
        scope.none
      end
    end
  end
end
