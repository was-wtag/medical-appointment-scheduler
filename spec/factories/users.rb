# frozen_string_literal: true

FactoryBot.define do
  factory :user_jane_doe, class: User do
    first_name { 'Jane' }
    last_name { 'Doe' }
    gender { 'female' }
    date_of_birth { '1990-01-01' }
    role { 'patient' }
    email { 'janedoe@example.com' }
    phone_number { '+8801611111111' }
    password { 'janedoepassword' }
    password_confirmation { 'janedoepassword' }

    trait :update_first_name do
      first_name { 'Janet' }
    end

    trait :missing_first_name do
      first_name { nil }
    end

    trait :inavlid_email_for_login do
      email { 'invalid_email' }
    end

    trait :inavlid_password_for_login do
      password { 'invalid_password' }
    end

    trait :role_is_doctor do
      role { User.roles[:doctor] }
    end

    trait :role_is_patient do
      role { User.roles[:patient] }
    end

    trait :update_status_to_active do
      status { 'active' }
    end
  end

  factory :user_john_doe, class: User do
    first_name { 'John' }
    last_name { 'Doe' }
    gender { 'male' }
    date_of_birth { '1990-01-01' }
    role { 'patient' }
    email { 'johndoe@example.com' }
    phone_number { '+8801711111111' }
    password { 'johndoepassword' }
    password_confirmation { 'johndoepassword' }

    trait :missing_first_name do
      first_name { nil }
    end

    trait :missing_last_name do
      last_name { nil }
    end

    trait :missing_email do
      email { nil }
    end

    trait :missing_phone_number do
      phone_number { nil }
    end

    trait :missing_password do
      password { nil }
    end

    trait :missing_password_confirmation do
      password_confirmation { nil }
    end

    trait :invalid_email do
      email { 'invalid_email' }
    end

    trait :invalid_phone_number do
      phone_number { 'invalid_phone_number' }
    end

    trait :password_too_short do
      password { 'short' }
      password_confirmation { 'short' }
    end

    trait :password_confirmation_mismatch do
      password { 'password' }
      password_confirmation { 'mismatch' }
    end

    trait :duplicate_email do
      email { FactoryBot.attributes_for(:user_jane_doe)[:email] }
    end

    trait :duplicate_phone_number do
      phone_number { FactoryBot.attributes_for(:user_jane_doe)[:phone_number] }
    end
  end
end
