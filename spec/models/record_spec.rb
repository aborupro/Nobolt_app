require 'rails_helper'

RSpec.describe Record, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:gym) { FactoryBot.create(:gym) }
  let(:record) { FactoryBot.build(:record, user_id: user.id, gym_id: gym.id )}

  describe "record" do
    it "is valid" do
      expect(record).to be_valid
    end
  
    it "is invalid with blank user_id" do
      record.user_id = nil
      expect(record).to be_invalid
    end
  
    it "is invalid with blank gym_id" do
      record.gym_id = nil
      expect(record).to be_invalid
    end
  
    it "is invalid with blank grade" do
      record.grade = nil
      expect(record).to be_invalid
    end
  
    it "is invalid with blank problem_id" do
      record.problem_id = nil
      expect(record).to be_invalid
    end

    context "order" do
      it "is the reverse order of creation time" do
        FactoryBot.create(:record, created_at: 10.minutes.ago)
        FactoryBot.create(:record, created_at: 3.years.ago)
        FactoryBot.create(:record, created_at: 2.hours.ago)
        most_recent_record = FactoryBot.create(:record, created_at: Time.zone.now)
        expect(Record.first).to eq most_recent_record
      end
    end
  end
end
