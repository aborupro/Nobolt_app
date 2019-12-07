FactoryBot.define do
  factory :micropost do
    content { "Lorem ipsum" }
    association :user
  end
end
