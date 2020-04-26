require 'rails_helper'

RSpec.describe "Records", type: :system do
  include ApplicationHelper
  let!(:user) { FactoryBot.create(:user, :with_records) }
  let!(:gym_1) { FactoryBot.create(:gym) }
  let!(:gym_2) { FactoryBot.create(:gym) }

  describe "record" do
    it "registers a valid gym" do
      system_log_in_as(user)
      click_link "ジム選択"
      expect(page).to have_current_path "/gyms"
      expect(page).to have_title full_title("ジム選択")
      expect {
        # 新規ジム登録ページに遷移
        click_on '新規ジム登録'
        expect(current_path).to eq new_gym_path
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
        # 一番はじめにヒットした大阪のジムを登録
        click_button 'ジム登録'
      }.to change(Gym, :count).by(1)
      expect(page).to have_content 'を保存しました'
      expect(page).to have_field 'ジム名', with: @gym_name
    end

    it "registers a valid record at the gym user recorded last time" do
      system_log_in_as(user)
      click_link "記録する"
      expect(page).to have_current_path "/records/new"
      expect(page).to have_title full_title("記録する")
      expect {
        select '3級', from: '級'
        fill_in '課題の種類（番号、形、色など課題を特定できる情報）', with: '100°四角'
        check '1度目のトライでクリアした場合にチェック'
        click_button '登録'
      }.to change(Record, :count).by(1)
      expect(page).to have_content '記録を保存しました'
      # 登録したジム内容を再度確認できる
      expect(page).to have_field 'ジム名', with: Gym.find(Record.find_by(user_id: user.id).gym_id).name
    end
  end
end
