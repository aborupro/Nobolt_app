FactoryBot.define do
  factory :gym do
    sequence(:name) { |n| "Gym_#{n}" }
    prefecture_code { 13 }
    picture { "sample_picture" }
    url { "MyString" }
    business_hours { "MyString" }
    address { "MyString" }
    price { "MyString" }
  end
end
