class Appointment < ApplicationRecord
  belongs_to :patient_user
  belongs_to :doctor_user
end
