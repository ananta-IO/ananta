require 'spec_helper'

describe 'Login', request: true, slow: true, js: true do
	context 'new user' do
		context 'facebook' do
			it 'fills in email and username in registration form' do
				pending
			end
		end

		context 'email' do
			it 'registers a new user' do
				visit root_path
				find(:css, 'a.login').click
				click_link "Don't have a Facebook account?"
				fill_in "email", with: 'nue-user@ananta.io'
				fill_in "password", with: '12345678'
				fill_in "username", with: 'nue-user'
				fill_in "project-name", with: 'ananta IO'
				click_button "Register"
				pending 'stub geocode and gravatar'
				# page.should have_content('Succesfully') 
			end
		end
	end

	context 'existing user' do
		before :all do
			FactoryGirl.create(:user, password: 12345678, email: 'ananta@ananta.io', username: 'ananta')
		end

		context 'facebook' do
			it 'logs in user' do
				pending
			end
		end

		context 'email' do
			it 'logs in user' do
				visit root_path
				find(:css, 'a.login').click
				click_link "Don't have a Facebook account?"
				fill_in "email", with: 'ananta@ananta.io'
				fill_in "password", with: '12345678'
				pending 'wait for login button'
				# click_button "Login"
				# page.should have_content('Succesfully') 
			end
		end

		context 'username' do
			it 'logs in user' do
				visit root_path
				find(:css, 'a.login').click
				click_link "Don't have a Facebook account?"
				fill_in "email", with: 'ananta'
				fill_in "password", with: '12345678'
				pending 'wait for login button'
				# click_button "Login"
				# page.should have_content('Succesfully') 
			end
		end
	end
end
