require 'rails_helper'

RSpec.describe "UsersSignups", type: :system do
  it "is invalid because it has no name" do
    visit signup_path
    fill_in "Name", with: ''
    fill_in "Email", with: 'user@invalid'
    fill_in "Password", with: 'foo'
    fill_in "Confirmation", with: 'bar'
    click_on 'Create my account'
    expect(current_path).to eq signup_path
    expect(page).to have_selector '#error_explanation'
    expect(page).to have_selector 'li', text: "Name can't be blank"
  end
end
