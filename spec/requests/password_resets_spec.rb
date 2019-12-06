require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:user) { FactoryBot.create(:user) }

  def post_password_reset
    post password_resets_path, params: { password_reset: { email: user.email } }
    @user = assigns(:user)
  end

  describe "GET /password_resets/:id/new" do
    it "is invalid email" do
      get new_password_reset_path
      expect(request.fullpath).to eq "/password_resets/new"
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(flash[:danger]).to be_truthy
      expect(request.fullpath).to eq "/password_resets"
    end

    it "is valid email" do
      get new_password_reset_path
      expect(request.fullpath).to eq "/password_resets/new"
      post password_resets_path, params: { password_reset: { email: user.email } }
      expect(user.reset_digest).to_not eq user.reload.reset_digest
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(flash[:info]).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq "/"
    end
  end

  describe "GET /password_resets/:id/edit" do
    it "is invalid email" do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: "")
      follow_redirect!
      expect(request.fullpath).to eq "/"
    end

    it "is invalid user" do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = assigns(:user)
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      follow_redirect!
      expect(request.fullpath).to eq "/"
    end

    it "is valid email and invalid token" do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = assigns(:user)
      get edit_password_reset_path('wrong token', email: "")
      follow_redirect!
      expect(request.fullpath).to eq "/"
    end

    it "is valid email and valid token" do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(request.fullpath).to eq "/password_resets/#{user.reset_token}/edit?email=#{CGI.escape(user.email)}"
    end
  end

  describe "GET /password_resets/:id/edit" do
    it "is invalid password and invalid password confirmation" do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      patch password_reset_path(user.reset_token),
        params: { email: user.email,
                  user: { password:              "foobaz",
                          password_confirmation: "barquux" } }
      user = assigns(:user)
      expect(user.errors.count).to eq 1
    end

    it "is blank password" do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
      user = assigns(:user)
      expect(user.errors.count).to eq 1
    end

    it "is expired token" do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = assigns(:user)
      user.update_attribute(:reset_sent_at, 3.hours.ago)
      get edit_password_reset_path(user.reset_token, email: user.email)
      patch password_reset_path(user.reset_token), params: {
        email: user.email,
        user: {
          password: "foobaz",
          password_confirmation: "foobaz"
        }
      }
      expect(flash[:danger]).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/password_resets/new'
    end

    it "is valid password and valid password confirmation" do
      post password_resets_path, params: { password_reset: { email: user.email } }
      user = assigns(:user)
      get edit_password_reset_path(user.reset_token, email: user.email)
      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
      user = assigns(:user)
      expect(flash[:success]).to be_truthy
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq "/users/1"
    end
  end
end
