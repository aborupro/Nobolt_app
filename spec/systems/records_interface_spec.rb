# require 'rails_helper'

# RSpec.describe "RecordsInterface", type: :system do
#   include ApplicationHelper

#   let!(:user) { FactoryBot.create(:user, :with_Records) }
#   let!(:other_user) { FactoryBot.create(:user) }

#   describe "record interface" do
#     it "posts invalid content" do
#       system_log_in_as(user)
#       visit root_path
#       expect(page).to have_css '.pagination', count: 1
#       expect{
#         fill_in '〇級をクリアしました！！', with: ' '
#         click_button '登録'
#       }.to_not change(Record, :count)
#       expect(page).to have_selector '#error_explanation'
#     end

#     it "posts valid content" do
#       system_log_in_as(user)
#       visit root_path
#       expect(page).to have_css '.pagination', count: 1
#       expect{
#         fill_in '〇級をクリアしました！！', with: 'ついに2級撃破です。'
#         click_button '投稿する'
#       }.to change(Record, :count).by(1)
#       expect(page).to have_current_path root_path
#       expect(page).to have_content 'ついに2級撃破です。'
#     end

#     it "posts valid content with picture" do
#       system_log_in_as(user)
#       visit root_path
#       expect(page).to have_css '.pagination', count: 1
#       expect(page).to have_selector 'input[type=file]'
#       expect{
#         fill_in '〇級をクリアしました！！', with: '3級クリア！ダイナミックな動きもこなせるようになりました。'
#         attach_file 'record_picture', "#{Rails.root}/spec/factories/boulder1.jpg"
#         click_button '投稿する'
#       }.to change(Record, :count).by(1)
#       expect(page).to have_current_path root_path
#       expect(page).to have_content '3級クリア！ダイナミックな動きもこなせるようになりました。'
#       expect(page).to have_selector '.record .content img'
#     end

#     it "delete record" do
#       system_log_in_as(user)
#       visit root_path
#       expect(page).to have_css '.pagination', count: 1
#       expect{
#         fill_in '〇級をクリアしました！！', with: 'ついに2級撃破です。'
#         click_button '投稿する'
#       }.to change(Record, :count).by(1)
#       expect(page).to have_selector 'a', text: '削除'
#       expect{
#         within '#record-101' do
#           click_on '削除'
#         end
#       }.to change(Record, :count).by(-1)
#     end

#     it "visits other user profile and does not have delete link" do
#       system_log_in_as(user)
#       visit user_path(other_user)
#       expect(page).to have_no_selector 'a', text: '削除'
#     end
#   end

#   describe "record sidebar count" do
#     it "is user who has already posted" do
#       system_log_in_as(user)
#       visit root_path
#       expect(page).to have_content "投稿数 #{user.records.count}"
#     end

#     it "is user who has not posted yet" do
#       system_log_in_as(other_user)
#       visit root_path
#       expect(page).to have_content "投稿数 0"
#       fill_in '〇級をクリアしました！！', with: 'ついに2級撃破です。'
#       click_button '投稿する'
#       visit root_path
#       expect(page).to have_content "投稿数 1"
#     end
#   end
# end