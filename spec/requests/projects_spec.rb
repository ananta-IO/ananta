require 'spec_helper'

describe "Projects" do
	describe "GET /projects" do
		it "displays projects" do
			project = FactoryGirl.create(:project)
			get projects_path
			page.should have_content(project.name)
		end
	end
end
