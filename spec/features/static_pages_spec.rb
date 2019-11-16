require 'rails_helper'

RSpec.feature "Statics", type: :feature do

  let(:base_title) { "Nobolog" }

  scenario "returns correct title" do
    visit root_path
    expect(page).to have_title "#{base_title}"
  end
end