FactoryBot.define do
  factory :record do
    sequence(:grade) { |n| "grade #{n}" }
    strong_point "MyString"
    sequence(:problem_id) { |n| "problem_id #{n}" }
    picture "MyString"
    association :user
    association :gym
  end
end
