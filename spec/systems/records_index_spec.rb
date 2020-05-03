require 'rails_helper'

RSpec.describe "RecordsIndex", type: :system do
  include ApplicationHelper
  let!(:user) { FactoryBot.create(:user, :with_records) }
  let!(:user_1) { FactoryBot.create(:user, :with_5_records) }
  let!(:user_2) { FactoryBot.create(:user, :with_5_records) }
  let!(:user_3) { FactoryBot.create(:user, :with_5_records) }

  before do
    Relationship.create(follower_id: user.id, followed_id: user_1.id)
    Relationship.create(follower_id: user.id, followed_id: user_2.id)
    Relationship.create(follower_id: user_1.id, followed_id: user.id)
    Relationship.create(follower_id: user_3.id, followed_id: user.id)
    system_log_in_as(user)
  end

  describe "record" do
    context "records of follow users" do
      it "has pagination, title, content" do
        visit root_path
        expect(page).to have_css '.pagination', count: 2
        expect(page).to have_title full_title("")
        expect(page).to have_content "完登記録(フォローユーザ)"
      end

      it "has follow users' records" do
        visit root_path
        expect(page).to have_content user_1.name, count:5
        expect(page).to have_content user_2.name, count:5
      end

      it "has no follow users' records" do
        visit root_path
        expect(page).to have_css '.pagination', count: 2
        expect(page).to_not have_content user_3.name
      end

      it "has own records" do
        visit root_path
        expect(page).to have_content user.name, count:20
      end

      it "has delete link in own record" do
        visit root_path
        expect(find('#record-100')).to have_selector 'a', text: '削除'
      end

      it "has no delete link in follow users' records" do
        visit root_path
        expect(find('#record-101')).to_not have_selector 'a', text: '削除'
        expect(find('#record-106')).to_not have_selector 'a', text: '削除'
      end

      it "deletes own record" do
        visit root_path
        expect(find('#record-100')).to have_selector 'a', text: '削除'
        expect{
          within '#record-100' do
            click_on '削除'
          end
        }.to change(Record, :count).by(-1)
      end

    end

    context "records of all users" do
      it "has pagination, title, content" do
        visit records_path
        expect(page).to have_css '.pagination', count: 2
        expect(page).to have_title full_title("完登記録(全ユーザ)")
        expect(page).to have_content "完登記録(全ユーザ)"
      end

      it "has own & follow & unfollow users' records" do
        visit records_path
        expect(page).to have_content user.name, count:15
        expect(page).to have_content user_1.name, count:5
        expect(page).to have_content user_2.name, count:5
        expect(page).to have_content user_3.name, count:5
      end

      it "has delete link in own record" do
        visit records_path
        expect(find('#record-100')).to have_selector 'a', text: '削除'
      end

      it "has no delete link in follow & unfollow users' records" do
        visit records_path
        expect(find('#record-101')).to_not have_selector 'a', text: '削除'
        expect(find('#record-106')).to_not have_selector 'a', text: '削除'
        expect(find('#record-111')).to_not have_selector 'a', text: '削除'
      end

      it "deletes own record" do
        visit records_path
        expect(find('#record-100')).to have_selector 'a', text: '削除'
        expect{
          within '#record-100' do
            click_on '削除'
          end
        }.to change(Record, :count).by(-1)
      end
    end
  end
end
