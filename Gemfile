source 'https://rubygems.org'
ruby "~> 2.7.0"

gem 'rails', '~> 6.1.7'
# concurrent-ruby 1.3.5 stopped requiring 'logger', which Rails < 7.1 relied on.
gem 'concurrent-ruby', '< 1.3.5'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.6'
gem 'bootsnap', require: false

# Asset pipeline (replaced by Propshaft + importmap later in the upgrade).
gem 'sprockets', '~> 3.7'
# Sprockets 3 passes JSON.parse(create_additions:), which json 3 removed.
gem 'json', '< 3'
gem 'sass-rails', '~> 5.1'
gem 'coffee-rails', '~> 4.2'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'font-awesome-rails'

gem 'devise', '~> 4.7'
gem 'meta-tags'
gem 'slim-rails'
gem 'redcarpet'
gem 'coderay'
gem 'will_paginate', '~> 3.3'
gem 'will_paginate-bootstrap'

group :development, :test do
  gem 'rspec-rails', '~> 6.1'
end

group :development do
  gem 'listen', '~> 3.3'
end

group :test do
  gem 'capybara', '~> 3.0'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'rails-controller-testing'
end
