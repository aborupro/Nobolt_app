require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { FactoryBot.build(:micropost) }
  
  describe "micropost" do
    it "is valid" do
      expect(micropost.valid?).to be_truthy
    end
  
    it "has user id" do
      micropost.user_id = nil
      expect(micropost.valid?).to be_falsey
    end

    context "content" do
      it "should be present" do
        micropost.content = " "
        expect(micropost.valid?).to be_falsey
      end

      it "requires less than 140 characters" do
        micropost.content = "a" * 141
        expect(micropost.valid?).to be_falsey
      end
    end
  end
end
