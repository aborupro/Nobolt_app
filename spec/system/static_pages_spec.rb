require 'rails_helper'

RSpec.describe "Statics", type: :system do

  let(:base_title) { "Nobolog" }

  it "returns correct home title" do
    visit root_path
    expect(page).to have_title "#{base_title}"
  end

  it "returns correct help title" do
    visit help_path
    expect(page).to have_title "使い方 | #{base_title}"
  end

  it "returns correct contact title" do
    visit contact_path
    expect(page).to have_title "お問い合わせ | #{base_title}"
  end

  describe "layout links" do
    it "have root link" do
      visit root_path
      expect(page).to have_link 'Nobolog', href: root_path
    end

    it "contains signup link" do
      visit root_path
      expect(page).to have_link '使い方', href: help_path
    end

    it "contains login link" do
      visit root_path
      expect(page).to have_link 'お問い合わせ', href: contact_path
    end
  end

end