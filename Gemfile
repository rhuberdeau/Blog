source "https://rubygems.org"
ruby "~> 4.0.0"

gem "rails", "~> 8.1.4"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 7.0"
gem "bootsnap", require: false

# Front end: no build step, no Node. Styles are plain CSS (Propshaft).
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

gem "bcrypt", "~> 3.1" # has_secure_password
gem "commonmarker", "~> 2.0" # GitHub-flavoured Markdown, with syntax highlighting

# AI writing assistant: Claude via the official SDK; jobs run in Puma.
gem "anthropic"
gem "solid_queue"

group :development do
  gem "kamal", require: false
end

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 8.0"
end

group :test do
  gem "capybara", "~> 3.40"
  gem "selenium-webdriver"
  gem "factory_bot_rails", "~> 6.4"
end
