FactoryBot.define do
  factory :user do
    name { "Michael Example" }
    sequence(:email) { |n| "michael#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
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

  factory :user_lana, class: User do
    name { "Lana Kane" }
    email { "hands@example.gov" }
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

  factory :user_n, class: User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    
    trait :with_microposts do
      after(:create) { |user_n| create_list(:micropost_n, 100, user: user_n) }
    end
  end
end