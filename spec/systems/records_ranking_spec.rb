require 'rails_helper'

RSpec.describe "RankingsRanking", type: :system do
  include ApplicationHelper
  let!(:grade_10) { Grade.create(name: "10級" ) }
  let!(:grade_9) { Grade.create(name: "9級" ) }
  let!(:gym) { FactoryBot.create(:gym) }
  let!(:other_gym) { FactoryBot.create(:gym) }

  let!(:user_1) { FactoryBot.create(:user, :with_records_random_time) }
  let!(:user_2) { FactoryBot.create(:user, :with_records_random_time) }
  let!(:user_3) { FactoryBot.create(:user, :with_records_random_time) }
  let!(:user_4) { FactoryBot.create(:user) }
  let!(:user_5) { FactoryBot.create(:user) }
  let!(:user_6) { FactoryBot.create(:user) }
  
  # 現在月,gym.nameの記録
  let!(:record_1) { FactoryBot.create(:record, user_id: user_4.id, gym_id: gym.id, grade: grade_10, strong_point: "1") }
  let!(:record_2) { FactoryBot.create(:record, user_id: user_4.id, gym_id: gym.id, grade: grade_10, strong_point: "0") }
  let!(:record_3) { FactoryBot.create(:record, user_id: user_4.id, gym_id: gym.id, grade: grade_9, strong_point: "0") }
  let!(:record_4) { FactoryBot.create(:record, user_id: user_4.id, gym_id: gym.id, grade: grade_9, strong_point: "1") }
  let!(:record_5) { FactoryBot.create(:record, user_id: user_4.id, gym_id: gym.id, grade: grade_9, strong_point: "0") }
  let!(:record_6) { FactoryBot.create(:record, user_id: user_5.id, gym_id: gym.id, grade: grade_9, strong_point: "1") }
  let!(:record_7) { FactoryBot.create(:record, user_id: user_5.id, gym_id: gym.id, grade: grade_9, strong_point: "0") }
  let!(:record_8) { FactoryBot.create(:record, user_id: user_6.id, gym_id: gym.id, grade: grade_10, strong_point: "1") }
  let!(:record_9) { FactoryBot.create(:record, user_id: user_6.id, gym_id: gym.id, grade: grade_9, strong_point: "0") }


  describe "ranking" do
    it "has correct score in the gym that the user recorded in" do
      system_log_in_as(user_5)
      click_link "ランキング"
      expect(page).to have_current_path "/rankings"
      expect(page).to have_title full_title("ランキング")
      expect(page).to have_select('集計期間', selected: Time.current.strftime("%Y年%m月"), options: ["全期間"] + (Record.last[:created_at].to_date.beginning_of_month..Date.today).select{|date| date.day == 1 }.map { |item| item.strftime("%Y年%m月")}.reverse)
      expect(page).to have_select('ジム', selected: '全てのジム', options: ["全てのジム"] + Gym.pluck("name"))
      select gym.name, from: 'ジム'
      click_button '集計'
      save_and_open_page
      expect(page).to have_content "あなたの順位は 3人中 2位 です"
      rank_number_4 = '#rank-number-' + "#{user_4.id}"
      user_name_4   = '#user-name-'   + "#{user_4.id}"
      score_4       = '#score-'       + "#{user_4.id}"
      rank_number_5 = '#rank-number-' + "#{user_5.id}"
      user_name_5   = '#user-name-'   + "#{user_5.id}"
      score_5       = '#score-'       + "#{user_5.id}"
      rank_number_6 = '#rank-number-' + "#{user_6.id}"
      user_name_6   = '#user-name-'   + "#{user_6.id}"
      score_6       = '#score-'       + "#{user_6.id}"
      expect(find(rank_number_4)).to have_content "1"
      expect(find(user_name_4)).to have_content user_4.name
      expect(find(score_4)).to have_content "100pt"
      expect(find(rank_number_5)).to have_content "2"
      expect(find(user_name_5)).to have_content user_5.name
      expect(find(score_5)).to have_content "50pt"
      expect(find(rank_number_6)).to have_content "3"
      expect(find(user_name_6)).to have_content user_6.name
      expect(find(score_6)).to have_content "40pt"
    end

    it "doesn't have score in the gym that the user didn't record in" do
      system_log_in_as(user_5)
      click_link "ランキング"
      expect(page).to have_current_path "/rankings"
      expect(page).to have_title full_title("ランキング")
      select other_gym.name, from: 'ジム'
      click_button '集計'
      expect(page).to have_content "あなたはこの期間、このジムで実績がありません"
      expect(page).to_not have_content user_4.name
      expect(page).to_not have_content user_5.name
      expect(page).to_not have_content user_6.name
    end

    it "has score in all term & all gyms" do
      system_log_in_as(user_5)
      click_link "ランキング"
      expect(page).to have_current_path "/rankings"
      expect(page).to have_title full_title("ランキング")
      select '全期間', from: '集計期間'
      click_button '集計'
      expect(page).to have_content '集計期間：全期間'
      expect(page).to have_content user_1.name
      expect(page).to have_content user_2.name
      expect(page).to have_content user_3.name
      expect(page).to have_content user_4.name
      expect(page).to have_content user_5.name
      expect(page).to have_content user_6.name
    end

    it "has score in all term & all gyms" do
      150.times do |n|
        FactoryBot.create(:user, :with_records_random_time)
      end
      system_log_in_as(user_5)
      click_link "ランキング"
      expect(page).to have_current_path "/rankings"
      expect(page).to have_title full_title("ランキング")
      select '全期間', from: '集計期間'
      click_button '集計'
      expect(page).to have_css '.pagination', count: 2
    end
      
  end
end
