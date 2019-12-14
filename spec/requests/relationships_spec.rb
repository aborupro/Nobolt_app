require 'rails_helper'

RSpec.describe "Relationships", type: :request do

  let(:user_1) { FactoryBot.create(:user_n) }
  let(:user_2) { FactoryBot.create(:user_n) }
  let!(:relationship_1) { Relationship.create(follower_id: user_1.id, followed_id: user_2.id) }

  describe "/relationships" do
    context "create" do
      it "requires logged-in user" do
        expect{
          post relationships_path
        }.to_not change(Relationship, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end

    context "destroy" do
      it "requires logged-in user" do
        expect{
          delete relationship_path(relationship_1)
        }.to_not change(Relationship, :count)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
      end
    end
    
  end
end
