require 'rails_helper'

RSpec.describe "Likes", type: :system do
  include ApplicationHelper
  let!(:user)  { FactoryBot.create(:user, :with_records) }
  let!(:user1) { FactoryBot.create(:user, :with_5_records) }
  let!(:user2) { FactoryBot.create(:user, :with_5_records) }
  let!(:user3) { FactoryBot.create(:user, :with_5_records) }
  
  before do
    Relationship.create(follower_id: user.id, followed_id: user1.id)
    Relationship.create(follower_id: user.id, followed_id: user2.id)
    Relationship.create(follower_id: user1.id, followed_id: user.id)
    Relationship.create(follower_id: user3.id, followed_id: user.id)
    Relationship.create(follower_id: user3.id, followed_id: user1.id)
    @user_record1  = Record.find_by(user_id: user.id)
    @user1_record1 = Record.find_by(user_id: user1.id)
    @user1_record2 = Record.where(user_id: user1.id).second
    @user2_record1 = Record.find_by(user_id: user2.id)
    @user3_record1 = Record.find_by(user_id: user3.id)

    # user1の1つ目の完登記録に2つナイスをつける
    @like1 = Like.create(user_id: user.id, record_id: @user1_record1.id)
    @like2 = Like.create(user_id: user3.id, record_id: @user1_record1.id)
    
    # user2の1つ目の完登記録に1つナイスをつける
    @like3 = Like.create(user_id: user1.id, record_id: @user2_record1.id)
    
    system_log_in_as(user)
  end

  describe "like" do
    context "visits follow users record page" do
      it "shows correct nice button and count", js: true do
        visit root_path
        expect(page).to have_css '.like', count: 30
        user1_record1_id = '#likes_buttons_' + "#{@user1_record1.id}"
        user1_record2_id = '#likes_buttons_' + "#{@user1_record2.id}"
        user2_record1_id = '#likes_buttons_' + "#{@user2_record1.id}"
        user3_record1_id = '#likes_buttons_' + "#{@user3_record1.id}"
        expect(find(user1_record1_id)).to have_content "2"
        expect(find(user1_record2_id)).to have_content "0"
        expect(find(user2_record1_id)).to have_content "1"
        expect(page).to_not have_css user3_record1_id

        expect {
          within user1_record1_id do
            find(".like").click
          end
          expect(page).to have_content "完登記録(フォローユーザ)"
          expect(find(user1_record1_id)).to have_content "1"
        }.to change(Like, :count).by(-1)

        expect {
          within user1_record2_id do
            find(".like").click
          end
          expect(page).to have_content "完登記録(フォローユーザ)"
          expect(find(user1_record2_id)).to have_content "1"
        }.to change(Like, :count).by(1)
      end
    end

    context "visits all users record page" do
      it "shows correct nice button and count", js: true do
        visit records_path
        expect(page).to have_css '.like', count: 30
        user1_record1_id = '#likes_buttons_' + "#{@user1_record1.id}"
        user1_record2_id = '#likes_buttons_' + "#{@user1_record2.id}"
        user2_record1_id = '#likes_buttons_' + "#{@user2_record1.id}"
        user3_record1_id = '#likes_buttons_' + "#{@user3_record1.id}"
        expect(find(user1_record1_id)).to have_content "2"
        expect(find(user1_record2_id)).to have_content "0"
        expect(find(user2_record1_id)).to have_content "1"
        expect(find(user3_record1_id)).to have_content "0"

        expect {
          within user1_record1_id do
            find(".like").click
          end
          expect(page).to have_content "完登記録(全ユーザ)"
          expect(find(user1_record1_id)).to have_content "1"
        }.to change(Like, :count).by(-1)

        expect {
          within user1_record2_id do
            find(".like").click
          end
          expect(page).to have_content "完登記録(全ユーザ)"
          expect(find(user1_record2_id)).to have_content "1"
        }.to change(Like, :count).by(1)
      end
    end
  end
  
end