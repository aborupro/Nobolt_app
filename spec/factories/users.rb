FactoryBot.define do
  factory :user do
    name { "Michael Example" }
    email { "michael@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :other_user, class: User do
    name { "Sterling Archer" }
    email { "duchess@example.gov" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :user_lana, class: User do
    name { "Lana Kane" }
    email { "hands@example.gov" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :user_malory, class: User do
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
  end
end