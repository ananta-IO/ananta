require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
	# Loading more in this block will cause your tests to run faster. However,
	# if you change any configuration or code from libraries loaded here, you'll
	# need to restart spork for it take effect.

	# This file is copied to spec/ when you run 'rails generate rspec:install'
	ENV["RAILS_ENV"] ||= 'test'
	require File.expand_path("../../config/environment", __FILE__)
	require 'rspec/rails'
	require 'cancan/matchers'
	require 'capybara/poltergeist'
	Capybara.javascript_driver = :poltergeist
	# Capybara.javascript_driver = :webkit

	# Requires supporting ruby files with custom matchers and macros, etc,
	# in spec/support/ and its subdirectories.
	Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

	RSpec.configure do |config|
		# == Mock Framework
		config.mock_with :rspec

		# Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
		config.fixture_path = "#{::Rails.root}/spec/fixtures"

		# If you're not using ActiveRecord, or you'd prefer not to run each of your
		# examples within a transaction, remove the following line or assign false
		# instead of true.
		config.use_transactional_fixtures = false

		# If true, the base class of anonymous controllers will be inferred
		# automatically. This will be the default behavior in future versions of
		# rspec-rails.
		config.infer_base_class_for_anonymous_controllers = false

		# Devise
		config.include Devise::TestHelpers, :type => :controller

		# Database Cleaner
		config.before(:suite) do
			DatabaseCleaner.strategy = :truncation
		end

		config.before(:each) do
			DatabaseCleaner.start
		end

		config.after(:each) do
			DatabaseCleaner.clean
		end

		# :wip tag
		# only runs tests tagged with :wip
		# if none tagged with wip runs all
		config.treat_symbols_as_metadata_keys_with_true_values = true
		config.filter_run :wip => true
		config.run_all_when_everything_filtered = true
	end

end

Spork.each_run do
	# This code will be run each time you run your specs.
	FactoryGirl.reload
	I18n.backend.reload!
end

ActionMailer::Base.delivery_method = :test