require 'rails_helper'

RSpec.describe Gym, type: :model do
  let(:gym) { FactoryBot.build(:gym) }
  let(:other_gym) { FactoryBot.build(:gym) }

  describe "name" do
    it "is valid with a name" do
      expect(gym).to be_valid
    end

    it "is invalid with a blank name" do
      gym.name = "　"
      expect(gym).to be_invalid
    end

    it "is invalid with duplicate name" do
      gym.name = "Nobolog 東京店"
      other_gym.name = "Nobolog 東京店"
      gym.save
      expect(other_gym).to be_invalid
    end
  end
end
