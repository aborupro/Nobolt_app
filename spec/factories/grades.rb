FactoryBot.define do
  factory :grade do
    sequence(:name) { |n| "grade#{n}" }
    grade_point { 1 }
  end
end
