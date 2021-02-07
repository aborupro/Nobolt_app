require 'rails_helper'

RSpec.describe 'Records', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  let!(:gym) { FactoryBot.create(:gym) }
  let!(:grade) { FactoryBot.create(:grade) }

  let!(:record) { FactoryBot.create(:record, user: user) }
  let!(:other_record) { FactoryBot.create(:record, user: other_user) }

  describe 'GET /records' do
    context 'create' do
      it 'does not create a record when not logged in' do
        expect do
          post records_path, params: { record: {
            grade_id: grade.id,
            strong_point: 'MyString',
            challenge: 'challenge 1',
            picture: 'MyString',
            gym_name: gym.name
          } }
        end.to_not change(Record, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end

    context 'destroy' do
      it 'does not destroy a record when not logged in' do
        expect do
          delete record_path(record)
        end.to_not change(Record, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end

      it "does not destroy other user's record" do
        log_in_as(user)
        expect do
          delete record_path(other_record)
        end.to_not change(Record, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end

      it 'destroys own record' do
        log_in_as(user)
        expect do
          delete record_path(record)
        end.to change(Record, :count).by(-1)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end
  end
end
