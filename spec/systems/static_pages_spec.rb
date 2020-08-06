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

  describe "layout links" do
    context "when not logged in" do
      it "contain root link" do
        visit root_path
        expect(page).to have_link 'Nobolog', href: root_path
      end
  
      it "contains help link" do
        visit root_path
        expect(page).to have_link '使い方', href: help_path
      end
  
      it "contains login link" do
        visit root_path
        expect(page).to have_link 'ログイン', href: login_path
      end
  
      it "contains sinup link" do
        visit root_path
        expect(page).to have_link '新規登録', href: signup_path
      end
    end
  end

end