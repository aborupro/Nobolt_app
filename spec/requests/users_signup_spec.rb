require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  #is_logged_in?メソッドを使えるようにするために、呼び出す
  include SessionsHelper

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

    it "is valid signup information" do
      get signup_path
      expect {
        post signup_path, params: {
          user: {
            name: "Example User",
            email: "user@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      }.to change(User, :count).by(1)
      expect(is_logged_in?).to be_truthy
    end
  end
end
