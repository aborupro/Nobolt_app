require 'rails_helper'

RSpec.describe "Logins", type: :system do

  let(:user) { FactoryBot.create(:user) }

  before do
    i = 100
    user = Array.new(i){{}}
    i.times do |n|
      user[n] = FactoryBot.create(:user_n)
    end
  end

  it "has index including pagination" do
    system_log_in_as(user)
    click_link "タイムライン"
    expect(page).to have_current_path "/users"
    expect(page).to have_css ".pagination", count: 2
    User.paginate(page: 1).each do |page_user|
      expect(page).to have_link page_user.name, href: user_path(page_user)
    end
  end
end