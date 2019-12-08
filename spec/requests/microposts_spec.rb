require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let!(:micropost) { FactoryBot.create(:micropost, :orange)}

  describe "GET /microposts" do
    it "dees not create a micropost when not logged in" do
      expect{
        post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
      }.to_not change(Micropost, :count)
      follow_redirect!
      expect(request.fullpath).to eq '/login'
    end

    it "does not destroy a micropost when not logged in" do
      expect{
        delete micropost_path(micropost)
      }.to_not change(Micropost, :count)
      follow_redirect!
      expect(request.fullpath).to eq '/login'
    end
  end
end
