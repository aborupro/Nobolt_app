FactoryBot.define do
  factory :grade do
    sequence(:name) { |n| "grade#{n}" }
  end
end
