require "json"

time_from = Time.parse('2018-1-1')
time_to   = Time.current

User.create!(name:  "壁崎 登る",
  email: "example@nobolt.com",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

149.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@nobolt.com"
  password = "password"
  User.create!(name:  name,
      email: email,
      password:              password,
      password_confirmation: password,
      activated: true,
      activated_at: Time.zone.now)
end

users_6 = User.order(:created_at).take(6)
users_150 = User.all
50.times do
  content = "#{rand(1..9)}級をクリアした！！"
  users_6.each { |user| user.microposts.create!(content: content) }
end

regions = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
  "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
  "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
  "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
  "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
  "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
  "熊本県","大分県","宮崎県","鹿児島県","沖縄県"
]

grades = [
  ['10級', 1],
  ['9級', 2],
  ['8級', 3],
  ['7級', 4],
  ['6級', 5],
  ['5級', 6],
  ['4級', 7],
  ['3級', 8],
  ['2級', 9],
  ['1級', 10],
  ['初段', 11],
  ['二段', 12],
  ['三段', 13],
  ['四級', 14],
  ['五段', 15],
  ['六段', 16] 
]

grades.each do |grade|
  Grade.create!(
    name: grade[0],
    grade_point: grade[1]
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
    url: "https://nobolt.com",
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

users_150.each do |user|
  user.records.create!(
    gym_id: @record_gym.id,
    grade_id: rand(1..16),
    challenge: "#{rand(1..13)}番",
    strong_point: "#{rand(0..1)}",
    created_at: Random.rand(time_from .. time_to)
  )
end

users = User.all
user  = users.first

following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

like_users = users[0..30]
like_users.each do |like_user|
  array = (1..Record.count).to_a
  array = array.sort_by{rand}[0..49]
  array.each do |i|
    like_user.likes.create(record_id: i)
  end
end