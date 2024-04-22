FactoryBot.define do
  factory :confirmation_token do
    user { nil }
    token { "MyString" }
  end
end
