FactoryBot.define do
  factory :gym do
    sequence(:name) { |n| "gym#{n}" }
    prefecture_code { 13 }
    picture { "sample_picture" }
    url { "https://nobolt.com" }
    business_hours { "9:00-23:00" }
    address { "MyString" }
    price { "1800円" }

    trait :with_picture_under_5MB do
      picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/boulder1.jpg'), 'image/jpg') }
    end

    trait :with_picture_over_5MB do
      picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/over5MB.jpeg'), 'image/jpeg') }
    end
  end
end
