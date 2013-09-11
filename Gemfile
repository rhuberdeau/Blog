source 'http://rubygems.org'

gem 'rails', '~> 4.0.0'
gem 'bcrypt-ruby', '~> 3.0.0'

# Bundle edge Rails instead:
# gem 'rails'


gem 'sass-rails'
gem 'coffee-rails'
gem 'bootstrap-sass'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 1.0.3'

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
  gem "rspec-rails"
end

group :test do
  #gem "factory_girl_rails"
  gem 'capybara', '< 2.0.0'
  gem 'database_cleaner'
  gem 'cucumber-rails', require: false
  gem 'factory_girl_rails'
end

# Bundle the extra gems:
gem 'kaminari'
gem "coderay"
gem 'dalli'
gem 'memcachier'
gem 'tinymce-rails'

# add these gems to help with the transition:
#gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'blog_engine', git: 'git://github.com/rhuberdeau/Blog-Engine.git'
