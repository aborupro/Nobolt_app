require 'rails_helper'

RSpec.describe "Logins", type: :system do
  
  let(:user_1) { FactoryBot.create(:user_n) }
  let(:user_2) { FactoryBot.create(:user_n) }
  let(:user_3) { FactoryBot.create(:user_n) }
  let(:user_4) { FactoryBot.create(:user_n) }

  before do
    Relationship.create(follower_id: user_1.id, followed_id: user_2.id)
    Relationship.create(follower_id: user_1.id, followed_id: user_3.id)
    Relationship.create(follower_id: user_2.id, followed_id: user_1.id)
    Relationship.create(follower_id: user_4.id, followed_id: user_1.id)
    system_log_in_as(user_1)
  end

  it "has collect users in following page" do
    visit following_user_path(user_1)
    expect(user_1.following.empty?).to be_falsey
    expect(page).to have_content user_1.following.count.to_s
    user_1.following.each do |user|
       expect(page).to have_link user.name, href: user_path(user)
    end
  end

  it "has collect users in follower page" do
    visit followers_user_path(user_1)
    expect(user_1.followers.empty?).to be_falsey
    expect(page).to have_content user_1.followers.count.to_s
    user_1.followers.each do |user|
       expect(page).to have_link user.name, href: user_path(user)
    end
  end

end