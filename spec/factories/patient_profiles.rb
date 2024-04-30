# frozen_string_literal: true

FactoryBot.define do
  factory :patient_profile_jane_doe, class: PatientProfile do
    blood_group { 'a_positive' }
    height_cm { 170 }
    weight_kg { 70 }
    medical_history { 'No medical history' }
    nid_number { '1234567890' }
    association :user, factory: :user_jane_doe
  end

  trait :missing_blood_group do
    blood_group { nil }
  end

  trait :missing_height_cm do
    height_cm { nil }
  end

  trait :missing_weight_kg do
    weight_kg { nil }
  end

  trait :missing_nid_number do
    nid_number { nil }
  end

  trait :invalid_nid_number do
    nid_number { 'invalid_nid_number' }
  end

  trait :invalid_user_role do
    association :user, factory: %i[user_jane_doe role_is_doctor]
  end
end
