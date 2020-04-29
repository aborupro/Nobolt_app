require 'rails_helper'

RSpec.describe "UsersProfile", type: :system do
  include ApplicationHelper

  let!(:user) { FactoryBot.create(:user, :with_records) }
  # let!(:user) { FactoryBot.create(:user, :with_microposts) }

  # describe "GET /users/:id" do
  #   it "shows profile display" do
  #     visit user_path(user)
  #     expect(user.microposts.length).to eq 100
  #     expect(current_path).to eq '/users/1'
  #     expect(page).to have_title full_title("マイページ")
  #     expect(page).to have_selector 'h1', text: user.name
  #     expect(page).to have_selector 'h1 img'
  #     expect(page).to have_content user.microposts.count.to_s
  #     expect(page).to have_css '.pagination', count: 1
  #     user.microposts.paginate(page: 1).each do |micropost|
  #       expect(page).to have_content micropost.content
  #     end
  #   end

    describe "GET /users/:id" do
      it "shows profile display" do
        visit user_path(user)
        expect(user.records.length).to eq 100
        expect(current_path).to eq '/users/1'
        expect(page).to have_title full_title("マイページ")
        expect(page).to have_selector '.user_info', text: user.name
        expect(page).to have_selector 'h1 img'
        expect(page).to have_content user.records.count.to_s
        expect(page).to have_css '.pagination', count: 1
        user.records.paginate(page: 1).each do |record|
          expect(page).to have_content record.grade.name
          expect(page).to have_content "good" if record.strong_point == "1"
          expect(page).to have_content record.challenge
          expect(page).to have_content Gym.find_by(id:record.gym_id).name
        end
      end

    it "shows follow and follower count" do
      visit user_path(user)
      expect(current_path).to eq '/users/1'
      expect(page).to have_content user.active_relationships.count.to_s
      expect(page).to have_content user.passive_relationships.count.to_s
    end
  end
end
