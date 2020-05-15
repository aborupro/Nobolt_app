require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:record) { FactoryBot.create(:record) }
  let!(:like) { FactoryBot.create(:like, user_id: user.id, record_id: record.id) }

  describe "like" do
    context "valid like" do
      it "is valid" do
        expect(like.valid?).to be_truthy
      end
    end

    context "nil user_id" do
      it "is invalid" do
        like.user_id = nil
        expect(like.valid?).to be_falsey
      end
    end

    context "nil record_id" do
      it "is invalid" do
        like.record_id = nil
        expect(like.valid?).to be_falsey
      end
    end
  end
end
