require "json"

time_from = Time.parse('2018-1-1')
time_to   = Time.current

User.create!(name:  "壁崎 登る",
  email: "example@nobolog.com",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@nobolog.com"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

users_6 = User.order(:created_at).take(6)
users_100 = User.take(100)
50.times do
  content = "#{rand(1..9)}級をクリアした！！"
  users_6.each { |user| user.microposts.create!(content: content) }
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

regions = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
  "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
  "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
  "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
  "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
  "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
  "熊本県","大分県","宮崎県","鹿児島県","沖縄県"
]

grades = ['10級', '9級', '8級', '7級', '6級', '5級', '4級', '3級', '2級', '1級',
  '初段', '二段', '三段', '四級', '五段', '六段' 
]

grades.each do |grade|
  Grade.create!(
    name: grade
  )
end

f = File.open("app/assets/data/bouldering_gyms.json")
gyms = JSON.load(f)

gyms["results"].each do |gym|

  regions.each do |region|
    @seed_gym_prefecture = gym["formatted_address"][region]
    break if @seed_gym_prefecture == region
  end

  Gym.create!(
    name:  gym['name'],
    prefecture_code: (JpPrefecture::Prefecture.find name: @seed_gym_prefecture).code,
    address: gym['formatted_address'],
    url: "https://nobolog.com",
    business_hours: "9:00-22:00",
    price: "1800円"
  )

  @record_gym = Gym.find_by(name: gym['name'])

  5.times do
    users_6.each do |user|
      user.records.create!(
        gym_id: @record_gym.id,
        grade_id: rand(1..16),
        challenge: "#{rand(1..13)}番",
        strong_point: "#{rand(0..1)}",
        created_at: Random.rand(time_from .. time_to)
      )
    end
  end
end
f.close

users_100.each do |user|
  user.records.create!(
    gym_id: @record_gym.id,
    grade_id: rand(1..16),
    challenge: "#{rand(1..13)}番",
    strong_point: "#{rand(0..1)}",
    created_at: Random.rand(time_from .. time_to)
  )
end