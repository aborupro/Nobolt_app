require 'rails_helper'

RSpec.describe 'UsersIndex', type: :system do
  let(:user) { FactoryBot.create(:user) }

  let!(:admin) { FactoryBot.create(:user, admin: true) }
  let!(:non_admin) { FactoryBot.create(:user) }

  before do
    i = 100
    @user = Array.new(i) { {} }
    i.times do |n|
      @user[n] = FactoryBot.create(:user, :with_5_records)
    end
  end

  describe 'GET /users_index' do
    it 'has index including pagination' do
      system_log_in_as(user)
      find('#pc-dropdown').click_link 'アカウント'
      find('#pc-dropdown').click_link 'ユーザ一覧'
      expect(page).to have_current_path '/users'
      expect(page).to have_css '.pagination', count: 2
      User.paginate(page: 1, per_page: 25).each do |page_user|
        expect(page).to have_link page_user.name, href: user_path(page_user)
      end
    end

    context 'index' do
      it 'logged in as admin including pagination and delete links' do
        system_log_in_as(admin)
        find('#pc-dropdown').click_link 'アカウント'
        find('#pc-dropdown').click_link 'ユーザ一覧'
        expect(page).to have_current_path '/users'
        User.paginate(page: 1, per_page: 25).each do |page_user|
          expect(page).to have_link page_user.name, href: user_path(page_user)
          @temp_user = page_user
          expect(page).to have_link '削除', href: user_path(@temp_user) unless page_user == admin
        end
        expect do
          click_link '削除', href: user_path(non_admin)
        end.to change(User, :count).by(-1)
      end

      it 'logged in as non-admin' do
        system_log_in_as(non_admin)
        find('#pc-dropdown').click_link 'アカウント'
        find('#pc-dropdown').click_link 'ユーザ一覧'
        expect(page).to_not have_link '削除'
      end

      it "shows user correct user's score" do
        system_log_in_as(user)
        visit '/users'
        expect(current_path).to eq '/users'
        expect(find('#score_' + @user[0].id.to_s)).to have_content '100'
        expect(find('#score_' + @user[1].id.to_s)).to have_content '100'
        expect(find('#score_' + @user[2].id.to_s)).to have_content '100'
        expect(find('#score_' + @user[3].id.to_s)).to have_content '100'
        expect(find('#score_' + @user[4].id.to_s)).to have_content '100'
      end
    end
  end
end
