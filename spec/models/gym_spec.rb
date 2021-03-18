require 'rails_helper'

RSpec.describe Gym, type: :model do
  let(:gym) { FactoryBot.build(:gym) }
  let(:other_gym) { FactoryBot.build(:gym) }
  let(:gym_under_5MB_pic) { FactoryBot.build(:gym, :with_picture_under_5MB) }
  let(:gym_over_5MB_pic) { FactoryBot.build(:gym, :with_picture_over_5MB) }

  describe 'gym' do
    context 'can save' do
      it 'is valid' do
        expect(gym).to be_valid
      end

      it 'is valid that has a picture under 5MB' do
        expect(gym_under_5MB_pic).to be_valid
      end

      it 'is valid that has a blank url' do
        gym.url = ' '
        expect(gym).to be_valid
      end
    end

    context 'cannot save' do
      it 'is invalid with a blank name' do
        gym.name = '　'
        gym.valid?
        expect(gym.errors[:name]).to include('を入力してください')
      end

      it 'is invalid with a duplicate name' do
        gym.name = 'Nobolt 東京店'
        other_gym.name = 'Nobolt 東京店'
        gym.save
        other_gym.valid?
        expect(other_gym.errors[:name]).to include('はすでに存在します')
      end

      it 'is invalid with a picture over 5MB' do
        gym_over_5MB_pic.valid?
        expect(gym_over_5MB_pic.errors[:picture]).to include('画像は5MBが上限です')
      end

      it 'is invalid with an invalid url' do
        gym.url = 'aaaaa'
        gym.valid?
        expect(gym.errors[:url]).to include('は不正な値です')
      end

      it 'is invalid without a address' do
        gym.address = nil
        gym.valid?
        expect(gym.errors[:address]).to include('を入力してください')
      end

      it 'is invalid without a prefecture_code' do
        gym.prefecture_code = nil
        gym.valid?
        expect(gym.errors[:prefecture_code]).to include('を入力してください')
      end
    end
  end
end
