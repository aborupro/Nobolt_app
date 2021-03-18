require 'rails_helper'

RSpec.describe 'Records', type: :system do
  include ApplicationHelper
  let(:user) { FactoryBot.create(:user, :with_records) }
  let(:no_record_user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user, admin: true) }
  let!(:gym_1) { FactoryBot.create(:gym) }
  let!(:gym_2) { FactoryBot.create(:gym) }

  describe 'gym' do
    context 'register' do
      it 'registers a valid gym' do
        system_log_in_as(user)
        find('.pc-nav').click_link 'ジム選択'
        expect(page).to have_current_path '/gyms'
        expect(page).to have_title full_title('ジム選択')
        expect do
          # 新規ジム登録ページに遷移
          click_on '新規ジム登録'
          expect(current_path).to eq new_gym_path
          expect(page).to have_title full_title('新規ジム登録')
          # 大阪のジムを検索
          fill_in 'ジム検索', with: '大阪'
          click_button '検索'
          expect(page).to have_title full_title('新規ジム登録')
          # 検索した大阪のジムの中から一番はじめにヒットしたものを選択
          within first('tbody tr') do
            click_button '選択'
          end
          expect(page).to have_title full_title('新規ジム登録')
          @gym_name = find_by_id('gym_name').value
          # 一番はじめにヒットした大阪のジムを登録
          click_button 'ジム登録'
        end.to change(Gym, :count).by(1)
        expect(page).to have_content 'を保存しました'
        expect(page).to have_field 'ジム名', with: @gym_name
      end

      it 'registers an invalid gym' do
        system_log_in_as(user)
        find('.pc-nav').click_link 'ジム選択'
        expect(page).to have_current_path '/gyms'
        expect(page).to have_title full_title('ジム選択')
        expect do
          # 新規ジム登録ページに遷移
          click_on '新規ジム登録'
          expect(current_path).to eq new_gym_path
          expect(page).to have_title full_title('新規ジム登録')
          # 大阪のジムを検索
          fill_in 'ジム検索', with: '大阪'
          click_button '検索'
          expect(page).to have_title full_title('新規ジム登録')
          # 検索した大阪のジムの中から一番はじめにヒットしたものを選択
          within first('tbody tr') do
            click_button '選択'
          end
          expect(page).to have_title full_title('新規ジム登録')
          @gym_name = find_by_id('gym_name').value
          @gym_prefecture = find_by_id('gym_prefecture').value
          @gym_address = find_by_id('gym_address').value
          fill_in 'ジムのURL', with: 'aaaaa'
          # 一番はじめにヒットした大阪のジムを登録
          click_button 'ジム登録'
        end.to_not change(Gym, :count)
        expect(page).to have_content '1個のエラーがあります'
        expect(page).to have_content 'ジムのURLは不正な値です'
        expect(page).to have_field 'ジム名', with: @gym_name
        expect(page).to have_field '都道府県', with: @gym_prefecture
        expect(page).to have_field '住所', with: @gym_address
      end
    end

    context 'select' do
      it 'redirects to gym select page' do
        system_log_in_as(no_record_user)
        find('.pc-nav').click_link '記録する'
        expect(page).to have_current_path '/gyms'
        expect(page).to have_title full_title('ジム選択')
        expect(page).to have_content 'まずは、ジムを選択してください'
      end

      it 'selects correct gym' do
        system_log_in_as(no_record_user)
        find('.pc-nav').click_link 'ジム選択'
        expect(page).to have_current_path '/gyms'
        expect(page).to have_title full_title('ジム選択')
        expect(page).to have_content gym_1.name
        expect(page).to have_content gym_2.name
        fill_in '地名・キーワードで検索', with: gym_1.name
        click_button '検索'
        expect(page).to have_content gym_1.name
        expect(page).to_not have_content gym_2.name
      end
    end

    context 'delete' do
      it 'has delete link when logged in as admin' do
        i = 100
        gym = Array.new(i) { {} }
        i.times do |n|
          gym[n] = FactoryBot.create(:gym)
        end
        system_log_in_as(admin)
        find('.pc-nav').click_link 'ジム選択'
        expect(page).to have_current_path '/gyms'
        expect(page).to have_title full_title('ジム選択')
        Gym.paginate(page: 1).each do |page_gym|
          expect(page).to have_link '削除', href: gym_path(page_gym)
        end
        expect do
          click_link '削除', href: gym_path(Gym.paginate(page: 1).first)
        end.to change(Gym, :count).by(-1)
      end

      it 'has no delete link when logged in as non-admin' do
        system_log_in_as(user)
        find('.pc-nav').click_link 'ジム選択'
        expect(page).to_not have_link '削除'
      end
    end
  end
end
