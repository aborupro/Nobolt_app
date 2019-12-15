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
  end

  factory :other_user, class: User do
    name { "Sterling Archer" }
    email { "duchess@example.gov" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
  end

  factory :unactivated_user, class: User do
    name { "Malory Archer" }
    email { "boss@example.gov.gov" }
    password { "password" }
    password_confirmation { "password" }
  end
end