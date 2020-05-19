source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.4.9'

gem 'rails', '~> 5.2.3'
gem 'puma', '~> 3.11'
gem 'bootstrap', '~> 4.3.1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'coffee-script-source', '1.8.0'
gem 'jquery-rails', '~> 4.3'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'
gem 'carrierwave'
gem 'mini_magick'
gem 'will_paginate'
gem 'will_paginate-bootstrap4'
gem 'google_places'
gem 'jp_prefecture'
gem 'slim-rails'
gem 'html2slim'
gem 'ransack'
gem 'chartkick'
gem 'mysql2'
gem 'font-awesome-sass'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem "bootswatch", github: "thomaspark/bootswatch"
gem 'rails-i18n'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~>4.0.0'
  gem "factory_bot_rails", "~> 4.10.0"
  gem 'rails-controller-testing'
  gem 'faker'
  gem 'bullet'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'spring-commands-rspec'
  gem 'guard'
  gem 'guard-rspec', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'webdrivers'
  gem 'launchy', '~> 2.4.3'
  gem 'rspec-retry'
  
end

group :production do
  gem 'fog'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'devise'
