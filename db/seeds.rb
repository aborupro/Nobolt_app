require 'json'

time_from = Time.parse('2020-1-1')
time_to   = Time.current

picture_file = File.open("app/assets/images/climber#{[1, 2, 3, 4, 5, 6].sample}.jpg")
User.create!(name: '壁崎 登る',
             email: 'example@nobolt.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             picture: picture_file)
picture_file.close

picture_file = File.open("app/assets/images/climber#{[1, 2, 3, 4, 5, 6].sample}.jpg")
User.create!(name: 'ゲストユーザ',
             email: 'guest@nobolt.com',
             password: 'pass-guest',
             password_confirmation: 'pass-guest',
             activated: true,
             activated_at: Time.zone.now,
             picture: picture_file)

78.times do |n|
  picture_file = File.open("app/assets/images/climber#{[1, 2, 3, 4, 5, 6].sample}.jpg")
  name = Faker::Name.name
  email = "example-#{n + 1}@nobolt.com"
  password = "password-#{n + 1}"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now,
               picture: picture_file)
  picture_file.close
end

users_6 = User.order(:created_at).take(6)
users_80 = User.all
50.times do
  content = "#{rand(1..9)}級をクリアした！！"
  users_6.each { |user| user.microposts.create!(content: content) }
end

regions = %W[\u5317\u6D77\u9053 \u9752\u68EE\u770C \u5CA9\u624B\u770C \u5BAE\u57CE\u770C \u79CB\u7530\u770C \u5C71\u5F62\u770C \u798F\u5CF6\u770C
             \u8328\u57CE\u770C \u6803\u6728\u770C \u7FA4\u99AC\u770C \u57FC\u7389\u770C \u5343\u8449\u770C \u6771\u4EAC\u90FD \u795E\u5948\u5DDD\u770C
             \u65B0\u6F5F\u770C \u5BCC\u5C71\u770C \u77F3\u5DDD\u770C \u798F\u4E95\u770C \u5C71\u68A8\u770C \u9577\u91CE\u770C \u5C90\u961C\u770C
             \u9759\u5CA1\u770C \u611B\u77E5\u770C \u4E09\u91CD\u770C \u6ECB\u8CC0\u770C \u4EAC\u90FD\u5E9C \u5927\u962A\u5E9C \u5175\u5EAB\u770C
             \u5948\u826F\u770C \u548C\u6B4C\u5C71\u770C \u9CE5\u53D6\u770C \u5CF6\u6839\u770C \u5CA1\u5C71\u770C \u5E83\u5CF6\u770C \u5C71\u53E3\u770C
             \u5FB3\u5CF6\u770C \u9999\u5DDD\u770C \u611B\u5A9B\u770C \u9AD8\u77E5\u770C \u798F\u5CA1\u770C \u4F50\u8CC0\u770C \u9577\u5D0E\u770C
             \u718A\u672C\u770C \u5927\u5206\u770C \u5BAE\u5D0E\u770C \u9E7F\u5150\u5CF6\u770C \u6C96\u7E04\u770C]

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

f = File.open('app/assets/data/bouldering_gyms.json')
gyms = JSON.load(f)

gyms['results'].each do |gym|
  regions.each do |region|
    @seed_gym_prefecture = gym['formatted_address'][region]
    break if @seed_gym_prefecture == region
  end

  picture_file = File.open("app/assets/images/bouldering_wall#{[1, 2, 3, 4, 5].sample}.jpg")
  Gym.create!(
    name: gym['name'],
    prefecture_code: (JpPrefecture::Prefecture.find name: @seed_gym_prefecture).code,
    address: gym['formatted_address'],
    picture: picture_file,
    url: 'https://nobolt.com',
    business_hours: '9:00-22:00',
    price: '1800円'
  )
  picture_file.close

  @record_gym = Gym.find_by(name: gym['name'])

  5.times do
    users_6.each do |user|
      user.records.create!(
        gym_id: @record_gym.id,
        grade_id: rand(1..16),
        challenge: "#{rand(1..13)}番",
        strong_point: rand(0..1).to_s,
        created_at: Random.rand(time_from..time_to)
      )
    end
  end
end
f.close

users_80.each do |user|
  user.records.create!(
    gym_id: @record_gym.id,
    grade_id: rand(1..16),
    challenge: "#{rand(1..13)}番",
    strong_point: rand(0..1).to_s,
    created_at: Random.rand(time_from..time_to)
  )
end

users = User.all
user  = users.second

following = users[2..25]
followers = users[3..20]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

like_users = users[0..30]
like_users.each do |like_user|
  array = (1..Record.count).to_a
  array = array.sort_by {rand}[0..49]
  array.each do |i|
    like_user.likes.create(record_id: i)
  end
end
