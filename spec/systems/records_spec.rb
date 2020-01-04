require 'rails_helper'

RSpec.describe "Records", type: :system do
  include ApplicationHelper
  let!(:user) { FactoryBot.create(:user, :with_microposts) }

  describe "records" do
    it "registers a new gym" do
      system_log_in_as(user)
      visit records_path
      expect(page).to have_title full_title("完登記録")
      expect {
        # 新規ジム登録ページに遷移
        click_on '新規ジム登録'
        expect(current_path).to eq gyms_path
        expect(page).to have_title full_title("新規ジム登録")
        # 大阪のジムを検索
        fill_in 'ジム検索', with: '大阪'
        click_button '検索'
        expect(page).to have_title full_title("新規ジム登録")
        # 検索した大阪のジムの中から一番はじめにヒットしたものを選択
        within first('tbody tr') do
          click_button '選択'
        end
        expect(page).to have_title full_title("新規ジム登録")
        @gym_name = find_by_id('gym_name').value
        @gym_prefecture = find_by_id('gym_prefecture').value
        # 一番はじめにヒットした大阪のジムを登録
        click_button 'ジム登録'
      }.to change(Gym, :count).by(1)
      expect(page).to have_content 'を保存しました'
      expect(page).to have_select('record_gym_name', selected: @gym_name)
      expect(page).to have_select('prefecture_key', selected: @gym_prefecture)
    end
  end
end
