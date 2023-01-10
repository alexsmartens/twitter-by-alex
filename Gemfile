source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails',  '6.0.6'
# Use Puma as the app server
gem 'puma', '5.6.4'
# Use SCSS for stylesheets
gem 'sassc-rails', '2.1.2'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '5.4.0'
# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '5.2.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.11.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '1.12.0', require: false

# Required for the sample app
gem 'image_processing',           '1.12.2'
gem 'mini_magick',                '4.9.5'
gem 'active_storage_validations', '0.9.8'
gem 'bcrypt',                     '3.1.18'
gem 'faker',                      '2.21.0'
gem 'will_paginate',              '3.3.1'
gem 'bootstrap-will_paginate',    '1.0.0'
gem 'bootstrap-sass',             '3.4.1'

# Use PostgreSQL as the database for Active Record
gem 'pg', '1.2.3'

# Added in https://github.com/learnenough/rails_tutorial_sample_app_7th_ed/edit/main/Gemfile
gem 'sprockets-rails',            '3.4.2'

group :development, :test do
  # Adding pry on its own has some issues with keywords like next and continue,
  # pry-byebug adds step-by-step debugging and stack navigation capabilities to
  # pry using byebug. For more: https://github.com/nixme/pry-nav/issues/20
  gem 'pry-byebug', '3.8.0'
end

group :development do
# Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'web-console', '4.2.0'
  gem 'listen', '3.4.1'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring', '2.1.1'
  gem 'rack-mini-profiler', '2.3.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '3.36.0'
  gem 'selenium-webdriver', '4.1.0'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers', '5.0.0'

  # Required for the sample app
  gem 'rails-controller-testing', '1.0.5'
  gem 'minitest',                 '5.15.0'
  gem 'minitest-reporters',       '1.5.0'
  gem 'guard',                    '2.18.0'
  gem 'guard-minitest',           '2.4.6'
end

group :production do
  gem 'aws-sdk-s3', '1.114.0', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Uncomment the following line if you're running Rails
# on a native Windows system:
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
