FactoryBot.define do
  factory :gym do
    sequence(:name) { |n| "Gym_#{n}" }
    prefecture { "東京都" }
    picture { "sample_picture" }
    url { "MyString" }
    business_hours { "MyString" }
    address { "MyString" }
    price { "MyString" }
  end
end
