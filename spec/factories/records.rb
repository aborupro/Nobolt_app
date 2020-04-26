FactoryBot.define do
  factory :record do
    sequence(:grade) { |n| "grade #{n}" }
    strong_point { "MyString" }
    sequence(:problem_id) { |n| "problem_id #{n}" }
    picture { "MyString" }
    association :user
    association :gym

    trait :with_picture_under_5MB do
      picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/boulder1.jpg'), 'image/jpg') }
    end

    trait :with_picture_over_5MB do
      picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/over5MB.jpeg'), 'image/jpeg') }
    end

  end
end
