FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "sanmple_user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    picture { "sample_picture" }
    admin { false }
    activated { true }

    trait :with_microposts do
      after(:create) { |user| create_list(:micropost_n, 100, user: user) }
    end

    trait :with_records do
      after(:create) { |user| create_list(:record, 100, user: user) }
    end

    trait :with_5_records do
      after(:create) { |user| create_list(:record, 5, user: user) }
    end

    time_from = Time.parse('2018-1-1')
    time_to   = Time.current

    trait :with_records_random_time do
      after(:create) { |user| create_list(:record, 5, user: user, created_at: Random.rand(time_from .. time_to)) }
    end

    trait :with_picture_under_5MB do
      picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/boulder1.jpg'), 'image/jpg') }
    end

    trait :with_picture_over_5MB do
      picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/factories/over5MB.jpeg'), 'image/jpeg') }
    end

  end
end