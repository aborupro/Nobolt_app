# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'rspec/retry'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rspec'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# docker-seleniumのコンテナブラウザを使用する設定
Capybara.register_driver :remote_chrome do |app|
  url = "http://chrome:4444/wd/hub"
  caps = ::Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:chromeOptions" => {
      "args" => [
        "no-sandbox",
        "headless",
        "disable-gpu",
        "window-size=1680,1050"
      ]
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :remote, url: url, desired_capabilities: caps)
end

RSpec.configure do |config|
  # ファイルアップロードのテストに使用する
  # config.include ActionDispatch::TestProcess
  # factoryBot内での呼び出し
  FactoryBot::SyntaxRunner.class_eval do
    include ActionDispatch::TestProcess
  end
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # Use Devise helpers in tests
  config.include Devise::Test::ControllerHelpers, type: :controller
  # config.include RequestSpecHelper, type: :request
  # ref https://qiita.com/yyh-gl/items/30bd91c2b33fdfbe49b5
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include ApplicationHelpers
  config.include LoginSupport

  # 実行中にリトライのステータスを表示する
  config.verbose_retry = true
  # リトライの原因となった例外を表示する
  config.display_try_failure_messages = true

  # js: true のフィーチャスペックのみリトライを有効にする
  config.around :each, :js do |ex|
    ex.run_with_retry retry: 3
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 80
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end

end
