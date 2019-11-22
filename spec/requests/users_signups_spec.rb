require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  describe "GET /signup" do
    it "is invalid signup information" do
      get signup_path
      expect {
        post signup_path, params: {
          user: {
            name: "",
            email: "user@invalid",
            password: "foo",
            password_confirmation: "bar"
          }
        }
      }.to_not change(User, :count)
    end
  end
end
