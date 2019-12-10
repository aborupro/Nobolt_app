require 'rails_helper'

RSpec.describe Relationship, type: :model do
  
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:other_user) }
  let(:relationship) { Relationship.new(follower_id: user.id,
                                        followed_id: other_user.id) }
  
  it "is valid" do
    expect(relationship.valid?).to be_truthy
  end

  it "requires a follower_id" do
    relationship.follower_id = nil
    expect(relationship.valid?).to be_falsey
  end

  it "requires a followed_id" do
    relationship.followed_id = nil
    expect(relationship.valid?).to be_falsey
  end
end
