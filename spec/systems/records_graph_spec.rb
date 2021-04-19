require 'rails_helper'

RSpec.describe 'RecordsGraph', type: :system do
  include ApplicationHelper
  let!(:user) { FactoryBot.create(:user) }
  let!(:record1) { FactoryBot.create(:record, user_id: user.id, created_at: Time.current) }
  let!(:record2) { FactoryBot.create(:record, user_id: user.id, created_at: 1.week.ago) }

  before do
    system_log_in_as(user)
  end

  def month_cal(date)
    if date.strftime('%m').to_i < 7
      # 1/1~6/30
      @from = date.beginning_of_year.strftime('%Y/%m/%d')
      @to = date.beginning_of_year.since(5.month).end_of_month.strftime('%Y/%m/%d')
    else
      # 7/1~12/31
      @from = date.end_of_year.ago(5.months).beginning_of_month.strftime('%Y/%m/%d')
      @to = date.end_of_year.strftime('%Y/%m/%d')
    end
  end

  describe 'graph' do
    context 'visits daily graph and click left & right tags' do
      it 'shows correct daily graph' do
        visit graphs_path
        expect(page).to have_current_path graphs_path
        expect(page).to have_title full_title('グラフ')
        expect(page).to have_content "#{user.name}さんのグラフ（日別）"
        expect(page).to have_content "#{Date.today.beginning_of_week(:sunday) \
                                      .strftime('%Y/%m/%d')}〜#{Date.today \
                                      .end_of_week(:sunday).strftime('%Y/%m/%d')}"
        expect(page).to have_css 'a.fa-chevron-left'
        expect(page).to have_css 'div.fa-chevron-right'
        expect(page).to have_css 'div#chart-1'

        find('a.fa-chevron-left').click
        expect(page).to have_title full_title('グラフ')
        expect(page).to have_content "#{user.name}さんのグラフ（日別）"
        expect(page).to have_content "#{7.day.ago.to_date.beginning_of_week(:sunday) \
                                      .strftime('%Y/%m/%d')}〜#{7.day.ago.to_date \
                                      .end_of_week(:sunday).strftime('%Y/%m/%d')}"
        expect(page).to have_css 'div.fa-chevron-left'
        expect(page).to have_css 'a.fa-chevron-right'
        expect(page).to have_css 'div#chart-1'

        find('a.fa-chevron-right').click
        expect(page).to have_title full_title('グラフ')
        expect(page).to have_content "#{user.name}さんのグラフ（日別）"
        expect(page).to have_content "#{Date.today.beginning_of_week(:sunday) \
                                      .strftime('%Y/%m/%d')}〜#{Date.today \
                                      .end_of_week(:sunday).strftime('%Y/%m/%d')}"
        expect(page).to have_css 'a.fa-chevron-left'
        expect(page).to have_css 'div.fa-chevron-right'
        expect(page).to have_css 'div#chart-1'
      end
    end

    context 'visits weekly graph and click left & right tags' do
      it 'shows correct weekly graph' do
        FactoryBot.create(:record, user_id: user.id, created_at: 8.week.ago)
        visit graphs_path
        click_link '週'
        expect(page).to have_current_path graphs_path(from_to: Date.today.strftime('%Y-%m-%d'), term: 'week')
        expect(page).to have_title full_title('グラフ')
        expect(page).to have_content "#{user.name}さんのグラフ（週別）"
        expect(page).to have_content "#{Date.today.ago(7.weeks).beginning_of_week(:sunday).to_date \
                                      .strftime('%Y/%m/%d')}〜#{Date.today.end_of_week(:sunday) \
                                      .to_date.strftime('%Y/%m/%d')}"
        expect(page).to have_css 'a.fa-chevron-left'
        expect(page).to have_css 'div.fa-chevron-right'
        expect(page).to have_css 'div#chart-1'

        find('a.fa-chevron-left').click
        expect(page).to have_title full_title('グラフ')
        expect(page).to have_content "#{user.name}さんのグラフ（週別）"
        expect(page).to have_content "#{(Date.today - 7 * 8).ago(7.weeks).beginning_of_week(:sunday) \
                                      .to_date.strftime('%Y/%m/%d')}〜#{(Date.today - 7 * 8) \
                                      .end_of_week(:sunday).to_date.strftime('%Y/%m/%d')}"
        expect(page).to have_css 'div.fa-chevron-left'
        expect(page).to have_css 'a.fa-chevron-right'
        expect(page).to have_css 'div#chart-1'

        find('a.fa-chevron-right').click
        expect(page).to have_title full_title('グラフ')
        expect(page).to have_content "#{user.name}さんのグラフ（週別）"
        expect(page).to have_content "#{Date.today.ago(7.weeks).beginning_of_week(:sunday).to_date \
                                      .strftime('%Y/%m/%d')}〜#{Date.today.end_of_week(:sunday) \
                                      .to_date.strftime('%Y/%m/%d')}"
        expect(page).to have_css 'a.fa-chevron-left'
        expect(page).to have_css 'div.fa-chevron-right'
        expect(page).to have_css 'div#chart-1'
      end
    end

    context 'visits monthly graph and click left & right tags' do
      it 'shows correct monthly graph' do
        FactoryBot.create(:record, user_id: user.id, created_at: 6.month.ago)
        visit graphs_path
        click_link '月'
        expect(page).to have_current_path graphs_path(from_to: Date.today.strftime('%Y-%m-%d'), term: 'month')
        expect(page).to have_title full_title('グラフ')
        expect(page).to have_content "#{user.name}さんのグラフ（月別）"
        month_cal(Date.today)
        expect(page).to have_content "#{@from}〜#{@to}"
        expect(page).to have_css 'a.fa-chevron-left'
        expect(page).to have_css 'div.fa-chevron-right'
        expect(page).to have_css 'div#chart-1'

        find('a.fa-chevron-left').click
        expect(page).to have_title full_title('グラフ')
        expect(page).to have_content "#{user.name}さんのグラフ（月別）"
        month_cal(Date.today << 6)
        expect(page).to have_content "#{@from}〜#{@to}"
        expect(page).to have_css 'div.fa-chevron-left'
        expect(page).to have_css 'a.fa-chevron-right'
        expect(page).to have_css 'div#chart-1'

        find('a.fa-chevron-right').click
        expect(page).to have_title full_title('グラフ')
        expect(page).to have_content "#{user.name}さんのグラフ（月別）"
        month_cal(Date.today)
        expect(page).to have_content "#{@from}〜#{@to}"
        expect(page).to have_css 'a.fa-chevron-left'
        expect(page).to have_css 'div.fa-chevron-right'
        expect(page).to have_css 'div#chart-1'
      end
    end

    context 'visits daily graph page' do
      it 'shows active day tag', js: true do
        visit graphs_path
        expect(page).to have_selector 'h3', text: '日'
        expect(page).to have_css 'a#day.nav-link.active'
      end
    end

    context 'visits weekly graph page' do
      it 'shows active week tag', js: true do
        visit graphs_path
        click_link '週'
        expect(page).to have_selector 'h3', text: '週'
        expect(page).to have_css 'a#week.nav-link.active'
      end
    end

    context 'visits monthly graph page' do
      it 'shows active month tag', js: true do
        visit graphs_path
        click_link '月'
        expect(page).to have_selector 'h3', text: '月'
        expect(page).to have_css 'a#month.nav-link.active'
      end
    end
  end
end
