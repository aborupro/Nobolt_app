require 'rails_helper'

RSpec.describe Gym, type: :model do
  let!(:gym) { FactoryBot.build(:gym) }

  describe "name" do
    it "is valid with a name" do
      expect(gym).to be_valid
    end

    it "is invalid with a blank name" do
      gym.name = "　"
      expect(gym).to be_invalid
    end
  end
end
