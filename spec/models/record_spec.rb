require 'rails_helper'

RSpec.describe Record, type: :model do
  let!(:user) { FactoryBot.create(:user) }
  let!(:gym) { FactoryBot.create(:gym) }
  let(:record) { FactoryBot.build(:record, :with_picture_under_5MB, user_id: user.id, gym_id: gym.id) }
  let(:record_5MB) { FactoryBot.build(:record, :with_picture_over_5MB, user_id: user.id, gym_id: gym.id) }

  describe 'record' do
    context 'can save' do
      it 'is valid that has a picture under 5MB' do
        expect(record).to be_valid
      end

      it 'is valid with a challenge that has less than 50 characters' do
        record.challenge = 'a' * 50
        expect(record).to be_valid
      end
    end

    context 'cannot save' do
      it 'is invalid without a grade_id' do
        record.grade_id = nil
        record.valid?
        expect(record.errors[:grade_id]).to include('を入力してください')
      end

      it 'is invalid without a strong_point' do
        record.strong_point = nil
        record.valid?
        expect(record.errors[:strong_point]).to include('を入力してください')
      end

      it 'is invalid without a challenge' do
        record.challenge = nil
        record.valid?
        expect(record.errors[:challenge]).to include('を入力してください')
      end

      it 'is invalid without a user_id' do
        record.user_id = nil
        record.valid?
        expect(record.errors[:user_id]).to include('を入力してください')
      end

      it 'is invalid without a gym_id' do
        record.gym_id = nil
        record.valid?
        expect(record.errors[:gym_id]).to include('を入力してください')
      end

      it 'is invalid with a challenge that has more than 51 characters' do
        record.challenge = 'a' * 51
        record.valid?
        expect(record.errors[:challenge]).to include('は50文字以内で入力してください')
      end

      it 'is invalid with a picture over 5MB' do
        record_5MB.valid?
        expect(record_5MB.errors[:picture]).to include('画像は5MBが上限です')
      end
    end

    context 'order' do
      it 'is the reverse order of creation time' do
        record_10m = FactoryBot.create(:record, created_at: 10.minutes.ago)
        record_3y  = FactoryBot.create(:record, created_at: 3.years.ago)
        record_2h  = FactoryBot.create(:record, created_at: 2.hours.ago)
        most_recent_record = FactoryBot.create(:record, created_at: Time.zone.now)
        expect(Record.first).to eq most_recent_record
        expect(Record.second).to eq record_10m
        expect(Record.third).to eq record_2h
        expect(Record.last).to eq record_3y
      end
    end
  end
end
