require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  let(:user_1) { FactoryBot.create(:user) }
  let(:user_2) { FactoryBot.create(:user) }
  let!(:relationship_1) { Relationship.create(follower_id: user_1.id, followed_id: user_2.id) }

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe '/relationships when not logged in' do
    context 'create' do
      it 'requires logged-in user' do
        expect do
          post relationships_path
        end.to_not change(Relationship, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end

    context 'destroy' do
      it 'requires logged-in user' do
        expect do
          delete relationship_path(relationship_1)
        end.to_not change(Relationship, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end
  end

  describe '/relationships when logged in' do
    before do
      log_in_as(user)
    end

    it 'follows a user with the standard way' do
      expect do
        post relationships_path, params: { followed_id: other_user.id }
      end.to change(user.following, :count).by(1)
    end

    it 'follows a user with Ajax' do
      expect do
        post relationships_path, xhr: true, params: { followed_id: other_user.id }
      end.to change(user.following, :count).by(1)
    end

    it 'unfollows a user with the standard way' do
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect do
        delete relationship_path(relationship)
      end.to change(user.following, :count).by(-1)
    end

    it 'unfollows a user with Ajax' do
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect do
        delete relationship_path(relationship), xhr: true
      end.to change(user.following, :count).by(-1)
    end
  end
end
