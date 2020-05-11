require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  #is_logged_in?メソッドを使えるようにするために、呼び出す
  include SessionsHelper

  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:user) { FactoryBot.create(:user, activated: false) }

  describe "GET /signup" do
    it "is invalid signup information" do
      get signup_path
      expect {
        post users_path, params: {
          user: {
            name: "",
            email: "user@invalid",
            password: "foo",
            password_confirmation: "bar"
          }
        }
      }.to_not change(User, :count)
    end

    it "is valid signup information with account activation" do
      get signup_path
      expect {
        post users_path, params: {
          user: {
            name: user.name,
            email: user.email,
            password: user.password,
            password_confirmation: user.password
          }
        }
      }.to change(User, :count).by(1)
      expect(user.activated?).to be_falsey
      #有効化していない状態でログインしてみる
      log_in_as(user)
      expect(is_logged_in?).to be_falsey
      # 有効化トークンが不正な場合
      get edit_account_activation_path("invalid token", email: user.email)
      expect(is_logged_in?).to be_falsey
      # トークンは正しいがメールアドレスが無効な場合
      get edit_account_activation_path(user.activation_token, email: 'wrong')
      expect(is_logged_in?).to be_falsey
      # 有効化トークンが正しい場合
      get edit_account_activation_path(user.activation_token, email: user.email)
      expect(user.reload.activated?).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq user_path(user)
      expect(is_logged_in?).to be_truthy
    end
  end
end
