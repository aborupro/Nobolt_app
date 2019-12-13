require 'rails_helper'

RSpec.describe "UsersRequests", type: :request do

  let(:user) { FactoryBot.create(:user) }
  
  describe "GET /signup_path" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end

  it "redirects to the login page when getting following without logged in" do
    get followers_user_path(user)
    expect(response).to redirect_to "/login"
  end

  it "redirects to the login page when getting followers without logged in" do
    get followers_user_path(user)
    expect(response).to redirect_to "/login"
  end
end
