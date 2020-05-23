require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:liked_record) { FactoryBot.create(:record) }
  let!(:like) { FactoryBot.create(:like, user_id: user.id, record_id: liked_record.id) }
  
  let!(:other_record) { FactoryBot.create(:record) }

  describe "/likes when not logged in" do
    context "create" do
      it "requires logged-in user" do
        expect{
          post record_likes_path(other_record.id)
        }.to_not change(Like, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end

    context "destroy" do
      it "requires logged-in user" do
        expect{
          delete record_like_path(record_id: liked_record.id, id: liked_record.likes[0].id)
        }.to_not change(Like, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end
  end

  describe "/relationships when logged in" do
    before do
      log_in_as(user)
    end

    it "likes a record with html" do
      expect{
        post record_likes_path(other_record.id)
      }.to change(Like, :count).by(1)
    end

    it "likes a record with Ajax" do
      expect{
        post record_likes_path(other_record.id), xhr: true
      }.to change(Like, :count).by(1)
    end

    it "deletes a like with html" do
      expect{
        delete record_like_path(record_id: liked_record.id, id: liked_record.likes[0].id)
      }.to change(Like, :count).by(-1)
    end

    it "deletes a like with Ajax" do
      expect{
        delete record_like_path(record_id: liked_record.id, id: liked_record.likes[0].id), xhr: true
      }.to change(Like, :count).by(-1)
    end

  end
end
