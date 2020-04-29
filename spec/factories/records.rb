FactoryBot.define do
  factory :record do
    strong_point { "MyString" }
    sequence(:challenge) { |n| "challenge #{n}" }
    picture { "MyString" }
    association :user
    association :gym
    association :grade

    trait :with_picture_under_5MB do
      picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/boulder1.jpg'), 'image/jpg') }
    end

    trait :with_picture_over_5MB do
      picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/over5MB.jpeg'), 'image/jpeg') }
    end

  end
end
