# frozen_string_literal: true

FactoryBot.define do
  factory :doctor_profile_jane_doe, class: DoctorProfile do
    specialty { 'general' }
    chamber_address { 'Dhaka, Bangladesh' }
    registration_number { '1234567890' }
    association :user, factory: %i[user_jane_doe role_is_doctor]

    trait :missing_specialty do
      specialty { nil }
    end

    trait :missing_chamber_address do
      chamber_address { nil }
    end

    trait :missing_registration_number do
      registration_number { nil }
    end

    trait :invalid_user_role do
      association :user, factory: %i[user_jane_doe role_is_patient]
    end

    trait :update_specialty do
      specialty { 'cardiologist' }
    end
  end
end
