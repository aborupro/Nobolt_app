require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:micropost) { FactoryBot.build(:micropost, :micropost_1) }
  
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

    context "order" do
      it "is the reverse order of creation time" do
        FactoryBot.create(:micropost, :orange)
        FactoryBot.create(:micropost, :tau_manifesto)
        FactoryBot.create(:micropost, :cat_video)
        most_recent = FactoryBot.create(:micropost, :most_recent)
        expect(Micropost.first).to eq most_recent
      end
    end
  end
end
