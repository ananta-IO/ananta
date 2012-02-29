require 'spec_helper'

describe "projects/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :usrname => "username"
    ))
    @project = assign(:project, stub_model(Project,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_projects_path(@user, @project), :method => "post" do
      assert_select "input#project_name", :name => "project[name]"
      assert_select "textarea#project_description", :name => "project[description]"
    end
  end
end
