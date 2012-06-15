require 'spec_helper'

describe "Projects", request: true, slow: true do
	context "index projects" do
		it "displays projects" do
			project = FactoryGirl.create(:project)
			visit projects_path
			page.should have_content(project.name) 
		end
	end
	context "show project" do
		it "displays project" do
			project = FactoryGirl.create(:project)
			visit user_projects_path([project.user, project])
			page.should have_content(project.name) 
		end
	end
end
