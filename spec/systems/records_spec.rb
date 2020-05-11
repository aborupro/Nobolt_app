require 'rails_helper'

RSpec.describe "Records", type: :system do
  include ApplicationHelper
  let!(:user) { FactoryBot.create(:user, :with_records) }
  let(:other_user) { FactoryBot.create(:user, :with_records) }
  let(:no_record_user) { FactoryBot.create(:user) }
  let!(:gym_1) { FactoryBot.create(:gym) }
  let!(:gym_2) { FactoryBot.create(:gym) }
  let!(:grade) { FactoryBot.create(:grade, name: "3級") }

  describe "record" do
    it "posts a valid record at the gym recorded last time" do
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
      expect(page).to have_current_path "/records"
    end

    it "posts an invalid record at the gym recorded last time" do
      system_log_in_as(user)
      click_link "記録する"
      expect(page).to have_current_path "/records/new"
      expect(page).to have_title full_title("記録する")
      expect {
        select '3級', from: '級'
        check '1度目のトライでクリアした場合にチェック'
        click_button '登録'
      }.to_not change(Record, :count)
      expect(page).to have_content '1個のエラーがあります'
      expect(page).to have_content '課題の種類（番号、形、色など課題を特定できる情報）を入力してください'
      # 登録したジム内容を再度確認できる
      expect(page).to have_field 'ジム名', with: Gym.find(Record.find_by(user_id: user.id).gym_id).name
      expect(page).to have_current_path "/records"
    end

    it "posts valid record with a picture" do
      system_log_in_as(user)
      click_link "記録する"
      expect(page).to have_current_path "/records/new"
      expect(page).to have_title full_title("記録する")
      expect {
        select '3級', from: '級'
        fill_in '課題の種類（番号、形、色など課題を特定できる情報）', with: '100°四角'
        check '1度目のトライでクリアした場合にチェック'
        attach_file '課題の写真', "#{Rails.root}/spec/factories/boulder1.jpg"
        click_button '登録'
      }.to change(Record, :count).by(1)
      expect(page).to have_content '記録を保存しました'
      # 登録したジム内容を再度確認できる
      expect(page).to have_field 'ジム名', with: Gym.find(Record.find_by(user_id: user.id).gym_id).name
      expect(page).to have_current_path "/records"
    end

    it "deletes a record" do
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
      expect(page).to have_current_path "/records"
      visit root_path
      expect(page).to have_selector 'a', text: '削除'
      delete_record = '#record-' + "#{Record.find_by(user_id: user.id).id}"
      expect{
        within delete_record do
          click_on '削除'
        end
      }.to change(Record, :count).by(-1)
    end

    it "visits other user profile and does not have delete link" do
      system_log_in_as(user)
      visit user_path(other_user)
      expect(page).to have_no_selector 'a', text: '削除'
    end

    context "record count" do
      it "is a user who has records" do
        system_log_in_as(user)
        visit user_path(user)
        expect(page).to have_content "マイ完登記録 (#{user.records.count})"
      end
  
      it "is a user who has no record" do
        system_log_in_as(no_record_user)
        click_link '記録する'
        expect(page).to have_current_path "/gyms"
        expect(page).to have_title full_title("ジム選択")
        expect(page).to have_content 'まずは、ジムを選択してください'
        within first('.gym_list') do
          click_link 'Gym'
        end
        expect(page).to have_title full_title("記録する")
        expect {
          select '3級', from: '級'
          fill_in '課題の種類（番号、形、色など課題を特定できる情報）', with: '100°四角'
          check '1度目のトライでクリアした場合にチェック'
          click_button '登録'
        }.to change(Record, :count).by(1)
        visit user_path(no_record_user)
        expect(page).to have_content "マイ完登記録 (1)"
      end
    end
  end
end
