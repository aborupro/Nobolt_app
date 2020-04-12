require 'rails_helper'

RSpec.describe "Records", type: :system do
  include ApplicationHelper
  let!(:user) { FactoryBot.create(:user, :with_microposts) }
  let!(:gym_1) { FactoryBot.create(:gym, :prefecture_kanagawa) }
  let!(:gym_2) { FactoryBot.create(:gym, :prefecture_kanagawa) }

  describe "record" do
    it "registers a valid gym" do
      system_log_in_as(user)
      click_link "記録する"
      expect(page).to have_current_path "/records"
      expect(page).to have_title full_title("記録する")
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

    it "registers a valid record" do
      system_log_in_as(user)
      click_link "記録する"
      expect(page).to have_current_path "/records"
      expect(page).to have_title full_title("記録する")
      expect {
        select gym_2.prefecture, from: 'ジム検索'
        select gym_2.name, from: 'ジム名'
        select '3級', from: '級'
        fill_in '課題の種類（番号、形、色など課題を特定できる情報）', with: '100°四角'
        check '1度目のトライでクリアした場合にチェック'
        click_button '登録'
      }.to change(Record, :count).by(1)
      expect(page).to have_content '記録を保存しました'
      # 登録したジム内容を再度確認できる
      expect(page).to have_select('record_gym_name', selected: gym_2.name)
      expect(page).to have_select('prefecture_key', selected: gym_2.prefecture)
    end
  end
end
