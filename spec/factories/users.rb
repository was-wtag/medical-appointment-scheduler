FactoryBot.define do
  female_user_email = FFaker::Internet.unique.email

  factory :female_user, class: User do
    first_name { FFaker::Name.first_name_female }
    last_name { FFaker::Name.last_name }
    gender { 'female' }
    date_of_birth { FFaker::Time.date }
    role { 'patient' }
    email { female_user_email }
    phone_number { '+8801711111111' }
    password { FFaker::Internet.password }
    password_confirmation { password }

    trait :update_first_name do
      first_name { FFaker::Name.first_name_female }
    end

    trait :missing_first_name do
      first_name { nil }
    end
  end

  factory :male_user, class: User do
    first_name { FFaker::Name.first_name_male }
    last_name { FFaker::Name.last_name }
    gender { 'male' }
    date_of_birth { FFaker::Time.date }
    role { 'patient' }
    email { FFaker::Internet.unique.email }
    phone_number { '+8801611111111' }
    password { FFaker::Internet.password }
    password_confirmation { password }

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
      email { female_user_email }
    end

    trait :duplicate_phone_number do
      phone_number { FactoryBot.attributes_for(:female_user)[:phone_number] }
    end
  end
end
