require 'rails_helper'

RSpec.describe "Logins", type: :system do

  def login_with_invalid_information
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    find(".f-submit").click
  end

  describe "Login" do
    context "invalid" do
      it "has invalid information and danger message" do
        visit login_path
        expect(current_path).to eq login_path
        login_with_invalid_information
        expect(current_path).to eq login_path
        expect(page).to have_selector '.alert-danger'
        visit root_path
        expect(page).to_not have_selector '.alert-danger'
      end
    end
  end
end