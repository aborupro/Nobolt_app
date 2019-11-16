require 'rails_helper'

RSpec.feature "Statics", type: :feature do

  let(:base_title) { "Nobolog" }

  scenario "returns correct home title" do
    visit root_path
    expect(page).to have_title "#{base_title}"
  end

  scenario "returns correct help title" do
    visit help_path
    expect(page).to have_title "使い方 | #{base_title}"
  end

end