FactoryBot.define do
  factory :appointment do
    scheduled_time { "2024-05-06 15:28:53" }
    duration_minutes { 1 }
    status { 1 }
    patient_user { nil }
    doctor_user { nil }
  end
end
