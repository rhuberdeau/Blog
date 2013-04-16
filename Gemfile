source 'http://rubygems.org'

gem 'rails', '3.2.6'
gem 'bcrypt-ruby'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'


group :production, :staging do
  gem "pg"
end

group :production do
  #gem 'therubyracer-heroku'
end

group :development, :test do
  gem "pg"
  gem 'annotate'
end

group :test do
  #gem "factory_girl_rails"
  gem "capybara", '< 2.0'
  gem "rspec-rails"
  gem 'database_cleaner'
  gem 'cucumber-rails', require: false
  gem 'factory_girl_rails'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem "simple_form"
gem 'kaminari'
gem "coderay"
gem 'sass-rails',   '~> 3.2.3'
gem 'bootstrap-sass'
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end