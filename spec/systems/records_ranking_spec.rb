require 'rails_helper'

RSpec.describe 'RankingsRanking', type: :system do
  include ApplicationHelper
  let!(:grade10) { Grade.create(name: '10級', grade_point: 1) }
  let!(:grade9) { Grade.create(name: '9級', grade_point: 2) }
  let!(:gym) { FactoryBot.create(:gym) }
  let!(:other_gym) { FactoryBot.create(:gym) }

  let!(:user1) { FactoryBot.create(:user, :with_records_random_time) }
  let!(:user2) { FactoryBot.create(:user, :with_records_random_time) }
  let!(:user3) { FactoryBot.create(:user, :with_records_random_time) }
  let!(:user4) { FactoryBot.create(:user) }
  let!(:user5) { FactoryBot.create(:user) }
  let!(:user6) { FactoryBot.create(:user) }

  # 現在月,gym.nameの記録
  let!(:record1) { FactoryBot.create(:record, user_id: user4.id, gym_id: gym.id, grade: grade10, strong_point: '1') }
  let!(:record2) { FactoryBot.create(:record, user_id: user4.id, gym_id: gym.id, grade: grade10, strong_point: '0') }
  let!(:record3) { FactoryBot.create(:record, user_id: user4.id, gym_id: gym.id, grade: grade9, strong_point: '0') }
  let!(:record4) { FactoryBot.create(:record, user_id: user4.id, gym_id: gym.id, grade: grade9, strong_point: '1') }
  let!(:record5) { FactoryBot.create(:record, user_id: user4.id, gym_id: gym.id, grade: grade9, strong_point: '0') }
  let!(:record6) { FactoryBot.create(:record, user_id: user5.id, gym_id: gym.id, grade: grade9, strong_point: '1') }
  let!(:record7) { FactoryBot.create(:record, user_id: user5.id, gym_id: gym.id, grade: grade9, strong_point: '0') }
  let!(:record8) { FactoryBot.create(:record, user_id: user6.id, gym_id: gym.id, grade: grade10, strong_point: '1') }
  let!(:record9) { FactoryBot.create(:record, user_id: user6.id, gym_id: gym.id, grade: grade9, strong_point: '0') }

  describe 'ranking' do
    it 'has correct score in the gym that the user recorded in', js: true do
      system_log_in_as(user5)
      find('.pc-nav').click_link 'ランキング'
      expect(page).to have_current_path '/rankings'
      expect(page).to have_title full_title('ランキング')
      expect(page).to have_select(:month,
                                  selected: Time.current.strftime('%Y年%m月'),
                                  options: ['全期間'] + (Record.last[:created_at] \
                                                        .to_date.beginning_of_month..Date.today).select \
                                                       { |date| date.day == 1 }.map \
                                                       { |item| item.strftime('%Y年%m月') }.reverse)
      expect(page).to have_select(:gym, selected: '全てのジム', options: ['全てのジム'] + Gym.pluck('name'))
      select gym.name, from: :gym
      click_button '集計'
      expect(page).to have_content 'あなたの順位は 3人中 2位 です'
      rank_number4 = "#rank-number-#{user4.id}"
      user_name4   = "#user-name-#{user4.id}"
      score4       = "#score-#{user4.id}"
      rank_number5 = "#rank-number-#{user5.id}"
      user_name5   = "#user-name-#{user5.id}"
      score5       = "#score-#{user5.id}"
      rank_number6 = "#rank-number-#{user6.id}"
      user_name6   = "#user-name-#{user6.id}"
      score6       = "#score-#{user6.id}"

      within find(rank_number4) do
        expect(find('.crown')[:src]).to have_content '/assets/crown-1.png'
      end
      expect(find(user_name4)).to have_content user4.name
      expect(find(score4)).to have_content '100pt'

      within find(rank_number5) do
        expect(find('.crown')[:src]).to have_content '/assets/crown-2.png'
      end
      expect(find(user_name5)).to have_content user5.name
      expect(find(score5)).to have_content '50pt'

      within find(rank_number6) do
        expect(find('.crown')[:src]).to have_content '/assets/crown-3.png'
      end
      expect(find(user_name6)).to have_content user6.name
      expect(find(score6)).to have_content '40pt'
    end

    it "doesn't have score in the gym that the user didn't record in", js: true do
      system_log_in_as(user5)
      find('.pc-nav').click_link 'ランキング'
      expect(page).to have_current_path '/rankings'
      expect(page).to have_title full_title('ランキング')
      select other_gym.name, from: :gym
      click_button '集計'
      expect(page).to have_content 'あなたはこの期間、このジムで実績がありません'
      expect(page).to_not have_content user4.name
      expect(page).to_not have_content user5.name
      expect(page).to_not have_content user6.name
    end

    it 'has score in all term & all gyms', js: true do
      system_log_in_as(user5)
      find('.pc-nav').click_link 'ランキング'
      expect(page).to have_current_path '/rankings'
      expect(page).to have_title full_title('ランキング')
      select '全期間', from: :month
      click_button '集計'
      expect(page).to have_content '集計期間：全期間'
      expect(page).to have_content user1.name
      expect(page).to have_content user2.name
      expect(page).to have_content user3.name
      expect(page).to have_content user4.name
      expect(page).to have_content user5.name
      expect(page).to have_content user6.name
    end

    it 'has score in all term & all gyms', js: true do
      150.times do |_n|
        FactoryBot.create(:user, :with_records_random_time)
      end
      system_log_in_as(user5)
      find('.pc-nav').click_link 'ランキング'
      expect(page).to have_current_path '/rankings'
      expect(page).to have_title full_title('ランキング')
      select '全期間', from: :month
      click_button '集計'
      expect(page).to have_css '.pagination', count: 2
    end
  end
end
