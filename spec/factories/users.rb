FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "sanmple_user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
    activated { true }

    trait :with_microposts do
      after(:create) { |user| create_list(:micropost_n, 100, user: user) }
    end

    trait :with_records do
      after(:create) { |user| create_list(:record, 100, user: user) }
    end
  end
end