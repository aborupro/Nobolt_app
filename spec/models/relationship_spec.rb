require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:relationship) do
    Relationship.new(follower_id: user.id,
                     followed_id: other_user.id)
  end

  describe 'validation' do
    it 'is valid' do
      expect(relationship.valid?).to be_truthy
    end

    it 'requires a follower_id' do
      relationship.follower_id = nil
      expect(relationship.valid?).to be_falsey
    end

    it 'requires a followed_id' do
      relationship.followed_id = nil
      expect(relationship.valid?).to be_falsey
    end
  end

  it 'follows and unfollows a user' do
    expect(user.following?(other_user)).to be_falsey
    user.follow(other_user)
    expect(user.following?(other_user)).to be_truthy
    expect(other_user.followers.include?(user)).to be_truthy
    user.unfollow(other_user)
    expect(user.following?(other_user)).to be_falsey
  end
end
