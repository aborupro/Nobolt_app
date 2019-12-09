FactoryBot.define do
  factory :micropost do
    association :user
    
    trait :micropost do
      content { "Lorem ipsum" }
      created_at { Time.zone.now }
    end

    trait :orange do
      content { "I just ate an orange!" }
      created_at { 10.minutes.ago }
    end
  
    trait :tau_manifesto do
      content { "Check out the @tauday site by @mhartl: http://tauday.com" }
      created_at { 3.years.ago }
    end
  
    trait :cat_video do
      content { "Sad cats are sad: http://youtu.be/PKffm2uI4dk" }
      created_at { 2.hours.ago }
    end
  
    trait :most_recent do
      content { "Writing a short test" }
      created_at { Time.zone.now }
    end
  end
  
  factory :micropost_n, class: Micropost do
    content { "#{rand(1..9)}級をクリアした！！" }
    created_at { 42.days.ago }
  end
end
