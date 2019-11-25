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
end