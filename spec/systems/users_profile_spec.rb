require 'rails_helper'

RSpec.describe "UsersProfile", type: :system do
  include ApplicationHelper

  let!(:grade1) { FactoryBot.create(:grade, name: "1級") }
  let!(:grade2) { FactoryBot.create(:grade, name: "2級") }
  let!(:gym1) { FactoryBot.create(:gym, name: "nobolog1") }
  let!(:gym2) { FactoryBot.create(:gym, name: "nobolog2") }

  let!(:user) { FactoryBot.create(:user, :with_records) }
  let!(:record1) { FactoryBot.create(:record, user_id: user.id, grade_id: grade1.id, gym_id: gym1.id) }
  let!(:record2) { FactoryBot.create(:record, user_id: user.id, grade_id: grade1.id, gym_id: gym2.id) }
  let!(:record3) { FactoryBot.create(:record, user_id: user.id, grade_id: grade2.id, gym_id: gym1.id) }
  before do
    system_log_in_as(user)
  end
  # let!(:user) { FactoryBot.create(:user, :with_microposts) }

  # describe "GET /users/:ofile display" do
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
        expect(user.records.length).to eq 103
        expect(current_path).to eq user_path(user)
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
      expect(current_path).to eq user_path(user)
      expect(page).to have_content user.active_relationships.count.to_s
      expect(page).to have_content user.passive_relationships.count.to_s
    end

    context "select grade" do
      it "shows selected grade record" do
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_content "1級"
        expect(page).to have_content "2級"
        expect(page).to have_content "nobolog1"
        expect(page).to have_content "nobolog2"
        expect(find("#grade_num_" + grade1.id.to_s)).to have_content "2"
        expect(find("#grade_num_" + grade2.id.to_s)).to have_content "1"
        expect(find("#gym_num_" + gym1.id.to_s)).to have_content "2"
        expect(find("#gym_num_" + gym2.id.to_s)).to have_content "1"
        expect(find('#grade_sum')).to have_content "103"
        expect(find('#gym_sum')).to have_content "103"
        click_link '1級'
        expect(page).to have_content "1級"
        expect(page).to_not have_content "2級"
        expect(page).to have_content "nobolog1"
        expect(page).to have_content "nobolog2"
        expect(find('#grade_sum')).to have_content "2"
        expect(find('#gym_sum')).to have_content "2"
      end
    end

    context "select gym" do
      it "shows selected gym record" do
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        expect(page).to have_content "1級"
        expect(page).to have_content "2級"
        expect(page).to have_content "nobolog1"
        expect(page).to have_content "nobolog2"
        expect(find("#grade_num_" + grade1.id.to_s)).to have_content "2"
        expect(find("#grade_num_" + grade2.id.to_s)).to have_content "1"
        expect(find("#gym_num_" + gym1.id.to_s)).to have_content "2"
        expect(find("#gym_num_" + gym2.id.to_s)).to have_content "1"
        expect(find('#grade_sum')).to have_content "103"
        expect(find('#gym_sum')).to have_content "103"
        click_link 'nobolog2'
        expect(page).to have_content "1級"
        expect(page).to_not have_content "2級"
        expect(page).to_not have_content "nobolog1"
        expect(page).to have_content "nobolog2"
        expect(find('#grade_sum')).to have_content "1"
        expect(find('#gym_sum')).to have_content "1"
      end
    end

    context "close&open table with click grade table" do
      it "hide table", js:true do
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        
        within '#grade-table' do
          expect(page).to have_content "1級"
          expect(page).to have_content "2級"
        end
        
        within '#gym-table' do
          expect(page).to have_content "nobolog1"
          expect(page).to have_content "nobolog2"
        end
        
        find("#grade-table-title").click
        
        within '#grade-table' do
          expect(page).to_not have_content "1級"
          expect(page).to_not have_content "2級"
        end

        within '#gym-table' do
          expect(page).to_not have_content "nobolog1"
          expect(page).to_not have_content "nobolog2"
        end

        find("#grade-table-title").click

        within '#grade-table' do
          expect(page).to have_content "1級"
          expect(page).to have_content "2級"
        end
        
        within '#gym-table' do
          expect(page).to have_content "nobolog1"
          expect(page).to have_content "nobolog2"
        end
      end
    end

    context "close&open table with click grade table" do
      it "hide table", js:true do
        visit user_path(user)
        expect(current_path).to eq user_path(user)
        
        within '#grade-table' do
          expect(page).to have_content "1級"
          expect(page).to have_content "2級"
        end
        
        within '#gym-table' do
          expect(page).to have_content "nobolog1"
          expect(page).to have_content "nobolog2"
        end
        
        find("#gym-table-title").click
        
        within '#grade-table' do
          expect(page).to_not have_content "1級"
          expect(page).to_not have_content "2級"
        end

        within '#gym-table' do
          expect(page).to_not have_content "nobolog1"
          expect(page).to_not have_content "nobolog2"
        end

        find("#gym-table-title").click

        within '#grade-table' do
          expect(page).to have_content "1級"
          expect(page).to have_content "2級"
        end
        
        within '#gym-table' do
          expect(page).to have_content "nobolog1"
          expect(page).to have_content "nobolog2"
        end
      end
    end
  end
end
