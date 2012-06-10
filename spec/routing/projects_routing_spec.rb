require "spec_helper"

describe ProjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/projects").should route_to("projects#index")
      get("/projects/page/1").should route_to("projects#index", :page => '1')
    end

    it "routes to #show" do
      get("/username/1").should route_to("projects#show", :user_id => "username", :id => "1")
    end

    it "routes to #new" do
      get("/username/new").should route_to("projects#new", :user_id => "username")
    end

    it "routes to #create" do
      post("/username").should route_to("projects#create", :user_id => "username")
    end

    it "routes to #edit" do
      get("/username/1/edit").should route_to("projects#edit", :user_id => "username", :id => "1")
    end

    it "routes to #update" do
      put("/username/1").should route_to("projects#update", :user_id => "username", :id => "1")
    end

    it "routes to #destroy" do
      delete("/username/1").should route_to("projects#destroy", :user_id => "username", :id => "1")
    end

  end
end
