require 'rails_helper'

RSpec.describe 'UsersHome', type: :system do
  include ApplicationHelper

  let(:user) { FactoryBot.create(:user) }

  it 'shows follow and follower count' do
    system_log_in_as(user)
    visit root_path
    expect(page).to have_content user.active_relationships.count.to_s
    expect(page).to have_content user.passive_relationships.count.to_s
  end
end
