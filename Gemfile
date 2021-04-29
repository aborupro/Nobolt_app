source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.4.9'

gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap', '~> 4.3.1'
gem 'carrierwave'
gem 'chartkick'
gem 'coffee-rails', '~> 4.2'
gem 'coffee-script-source', '1.8.0'
gem 'faker'
gem 'font-awesome-sass'
gem 'google_places'
gem 'html2slim'
gem 'jbuilder', '~> 2.5'
gem 'jp_prefecture'
gem 'jquery-rails', '~> 4.3'
gem 'mini_magick'
gem 'mysql2'
gem 'nokogiri'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.3'
gem 'ransack'
gem 'rename'
gem 'rubocop', require: false
gem 'rubocop-rails', require: false
gem 'sassc'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate'
gem 'will_paginate-bootstrap4'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootswatch', github: 'thomaspark/bootswatch'
gem 'rails-i18n'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 4.10.0'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~>4.0.0'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano-rbenv-vars'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'listen', '3.1.5'
  gem 'spring', '2.0.2'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'launchy', '~> 2.4.3'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'rspec-retry'
  gem 'webdrivers'
end

group :production do
  gem 'fog-aws'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'devise'
