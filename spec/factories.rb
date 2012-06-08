require File.join(Rails.root, 'lib/ananta/string')
include Ananta::String
include ActionDispatch::TestProcess


FactoryGirl.define do
	sequence :email do |n|
		"person#{n}@example.com"
	end
	sequence :name do |n|
		"Faker::Name.name #{n}"
	end
	sequence :username do |n|
		"user-#{base_convert_i_to_s(n, '', 65, 90)}"
	end


	factory :image do
		image_type 'avatar'
		image { fixture_file_upload("spec/fixtures/example.png", "image/png") }
		user
	end


	factory :location do
		name 'NYC'
		country 'US'
		city 'New York'
		state 'New York'
		zipcode 10001
		latitude 40.71435280
		longitude -74.00597309999999
		timezone 'America/New_York'
	end


	factory :profile, aliases: [:imageable] do
		name { generate :name }
		after_create { |p| FactoryGirl.create(:image, image_type:'avatar', imageable:p, user:p.user) }
	end


	factory :project do
		name { generate :name }
		description 'this is the best test project you will ever see'
		state 'planning'
		user
	end


	factory :user do
		username { generate :username }
		email { generate :email }
		password '12345678'
		permissions 2
		profile
		location
	end
end