source 'https://rubygems.org'

# The Framework
gem 'rails', '3.2.3'

# The Database
gem 'pg'

# The Server
gem 'thin'


# Authentications & Permissions
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-openid'
gem 'cancan'

# Slugging
gem 'friendly_id', '>= 4.0.0.beta14'

# Versioning
gem 'paper_trail'

# Clean RESTful controllers 
gem 'inherited_resources'
# and controller scopes
gem 'has_scope'

# Searching and Scoping made easier with method missing
# TODO: do we need either?
# gem 'searchlogic'
# gem 'meta_search'

# Tagging
gem 'acts-as-taggable-on'

# State Machine
gem 'state_machine'

# Voting
gem 'thumbs_up' #, '~> 0.4.6' # Heroku not working with 0.5.3 - bute we will try anyway # TODO: look into this more

# Pagination
gem 'kaminari'

# Images and Uploads
gem 'carrierwave'
gem 'fog'
gem 'rmagick'
gem 'gravtastic'

# Third-party APIs and services
gem 'koala'
gem 'geocoder'
gem 'ask_geo'

# Misc
gem 'rabl'
gem 'jquery-rails'
gem 'haml-rails'
gem 'simple_form'

# Really Misc
gem 'possessive' 


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'bootstrap-sass', '~> 2.0.1'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'compass-h5bp'
  gem 'haml_coffee_assets'
  gem 'rails-backbone'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end


group :development, :test, :sandbox do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
end


group :development do
  gem 'pry'
  gem 'heroku'
  # gem 'ruby-debug19', :require => 'ruby-debug'
end


group :test do
  gem 'rspec-rails', '~> 2.6'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'rake' 
end