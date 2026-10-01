source 'https://rubygems.org'
ruby "~> 4.0.0"

gem 'rails', '~> 8.1.4'
gem 'pg', '~> 1.1'
gem 'puma', '>= 7.0'
gem 'bootsnap', require: false

# Rails 8 front-end defaults: no build step, no Node.
gem 'propshaft'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'

gem 'devise', '~> 5.0'
gem 'meta-tags'
gem 'slim-rails'
gem 'redcarpet'
gem 'coderay'
gem 'will_paginate', '~> 4.0'

group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rspec-rails', '~> 8.0'
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'rails-controller-testing'
end
