require 'rails_helper'

RSpec.describe "UsersProfile", type: :system do
  include ApplicationHelper

  let!(:user) { FactoryBot.create(:user, :with_microposts) }

  describe "GET /users/:id" do
    it "shows profile display" do
      visit user_path(user)
      expect(user.microposts.length).to eq 100
      expect(current_path).to eq "/users/1"
      expect(page).to have_title full_title("マイページ")
      expect(page).to have_selector 'h1', text: user.name
      expect(page).to have_selector 'h1 img'
      expect(page).to have_content user.microposts.count.to_s
      expect(page).to have_css '.pagination', count: 1
      user.microposts.paginate(page: 1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end
  end
end
