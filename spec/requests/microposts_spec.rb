require 'rails_helper'

RSpec.describe 'Microposts', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  let!(:micropost) { FactoryBot.create(:micropost, :orange) }
  let!(:other_micropost) { FactoryBot.create(:micropost_n, user: other_user) }

  describe 'GET /microposts' do
    context 'create' do
      it 'dees not create a micropost when not logged in' do
        expect do
          post microposts_path, params: { micropost: { content: 'Lorem ipsum' } }
        end.to_not change(Micropost, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end

    context 'destroy' do
      it 'does not destroy a micropost when not logged in' do
        expect do
          delete micropost_path(micropost)
        end.to_not change(Micropost, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end

      it 'does not destroy a micropost for wrong micropost' do
        log_in_as(user)
        expect do
          delete micropost_path(other_micropost)
        end.to_not change(Micropost, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end
  end
end
