source 'https://rubygems.org'

gem 'rails', '3.2.1'


gem 'jbuilder' # Templates for JSON
gem 'jquery-rails'
gem 'haml-rails'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end


group :development, :test, :sandbox do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
end


group :development, :test do
  # Delvelopment
  gem 'pry'
  gem 'sqlite3' # TODO: Switch to pg on dev and test
  
  # Test
  gem 'rspec-rails', '~> 2.6'
  gem 'capybara'
  gem 'capybara-webkit'

  # Debug
  # gem 'ruby-debug19', :require => 'ruby-debug'
end


group :staging, :production, :sandbox do
  gem 'pg'
end


