require 'spec_helper'

describe "Pages", request: true, slow: true do
	describe "home page" do
		it "displays marq", js: true do
			visit root_path
			# save_and_open_page
			click_link '?'
			page.should have_content('You have answered every question on this page') 
		end
	end
end
