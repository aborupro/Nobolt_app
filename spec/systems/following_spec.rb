require 'rails_helper'

RSpec.describe 'Logins', type: :system do
  let(:user_1) { FactoryBot.create(:user, :with_5_records) }
  let(:user_2) { FactoryBot.create(:user, :with_5_records) }
  let(:user_3) { FactoryBot.create(:user, :with_5_records) }
  let(:user_4) { FactoryBot.create(:user, :with_5_records) }

  before do
    Relationship.create(follower_id: user_1.id, followed_id: user_2.id)
    Relationship.create(follower_id: user_1.id, followed_id: user_3.id)
    Relationship.create(follower_id: user_2.id, followed_id: user_1.id)
    Relationship.create(follower_id: user_4.id, followed_id: user_1.id)
    system_log_in_as(user_1)
  end

  it 'has correct users in following page' do
    visit following_user_path(user_1)
    expect(user_1.following.empty?).to be_falsey
    expect(page).to have_content user_1.following.count.to_s
    user_1.following.each do |user|
      expect(page).to have_link user.name, href: user_path(user)
    end
  end

  it 'has correct users in follower page' do
    visit followers_user_path(user_1)
    expect(user_1.followers.empty?).to be_falsey
    expect(page).to have_content user_1.followers.count.to_s
    user_1.followers.each do |user|
      expect(page).to have_link user.name, href: user_path(user)
    end
  end

  it 'has correct counts in following page' do
    visit following_user_path(user_1)
    user_1.following.each do |user|
      expect(find("#following_#{user.id}")).to have_content user.active_relationships.count.to_s
      expect(find("#followers_#{user.id}")).to have_content user.passive_relationships.count.to_s
      expect(find("#score_#{user.id}")).to have_content '100'
      expect(page).to have_link href: following_user_path(user)
      expect(page).to have_link href: followers_user_path(user)
    end
  end

  it 'has correct counts in followers page' do
    visit followers_user_path(user_1)
    user_1.followers.each do |user|
      expect(find("#following_#{user.id}")).to have_content user.active_relationships.count.to_s
      expect(find("#followers_#{user.id}")).to have_content user.passive_relationships.count.to_s
      expect(find("#score_#{user.id}")).to have_content '100'
      expect(page).to have_link href: following_user_path(user)
      expect(page).to have_link href: followers_user_path(user)
    end
  end
end
