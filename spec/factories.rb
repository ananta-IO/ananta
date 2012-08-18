require File.join(Rails.root, 'lib/ananta/string')
include Ananta::String
include ActionDispatch::TestProcess


FactoryGirl.define do
	sequence :email do |n|
		"person#{n}@example.com"
	end
	sequence :name do |n|
		"#{Faker::Name.name} #{n}"
	end
	sequence :username do |n|
		"user-#{base_convert_i_to_s(n, '', 65, 90)}"
	end
	sequence :question do |n|
		"What is the meaning of #{n}?"
	end


	factory :answer do
		state 'yes'
		question
		user
	end


	factory :image do
		image_type 'avatar'
		image { fixture_file_upload("spec/fixtures/example.png", "image/png") }
		imageable_type 'Profile'
		user
	end


	factory :location do
		name 'NYC'
		address 'New York, New York, 10001'
		# city 'New York'
		# state 'New York'
		# zipcode 10001
		lat 40.71435280
		lng -74.00597309999999
		# timezone 'America/New_York'
	end


	factory :profile, aliases: [:imageable] do
		name { generate :name }
		# after(:create) { |p| FactoryGirl.create(:image, image_type:'avatar', imageable:p, user:p.user) }
	end


	factory :project do
		name { generate :name }
		description Faker::Lorem.paragraph
		state 'planning'
		user
	end


	factory :question do
		question { generate :question }
		user
	end


	factory :user do
		username { generate :username }
		email { generate :email }
		password '12345678'
		permissions 2
		profile
		after(:build) do |u|
			FactoryGirl.build(:location, locatable: u)
			u.projects.new( name: generate(:name) ) 
		end
	end
end