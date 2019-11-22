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

  it "is valid because it fulfils condition of input" do
    visit signup_path
    fill_in "Name", with: 'Example User'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'password'
    click_on 'Create my account'
    expect(current_path).to eq user_path(1)
    expect(page).not_to have_selector '#error_explanation'
  end
end
