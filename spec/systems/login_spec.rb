require 'rails_helper'

RSpec.describe "Logins", type: :system do
  let(:user) { FactoryBot.create(:user) }

  def login_with_invalid_information
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    find("#f-login-submit").click
  end

  def login_with_valid_information
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    find("#f-login-submit").click
  end

  describe "Login" do
    context "invalid" do
      it "has invalid information and danger message then deletes flash message" do
        visit login_path
        expect(page).to have_css '#f-login-submit'
        login_with_invalid_information
        expect(page).to have_css '#f-login-submit'
        expect(page).to have_css '.alert-danger'
        visit root_path
        expect(page).to_not have_css '.alert-danger'
      end
    end

    context "valid information" do
      it "login with valid information followed by logout" do
        visit login_path
        login_with_valid_information
        expect(page).to have_current_path user_path(1)
        expect(page).to_not have_link 'ログイン', href: login_path
        expect(page).to have_link 'ログアウト', href: logout_path
        expect(page).to have_link 'ユーザホーム', href: user_path(1)
        click_link "アカウント"
        click_link "ログアウト"
        expect(page).to have_current_path root_path
        expect(page).to have_link 'ログイン', href: login_path
        expect(page).to_not have_link 'ログアウト', href: logout_path
        expect(page).to_not have_link 'ユーザホーム', href: user_path(1)
      end
    end
  end
end