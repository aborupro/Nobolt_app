require 'rails_helper'

RSpec.describe "UsersRequests", type: :request do
  describe "GET /signup_path" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end
end
