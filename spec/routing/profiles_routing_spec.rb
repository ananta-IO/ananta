require "spec_helper"

describe ProfilesController, routing: true, slow: true do
  describe "routing" do

    it "routes to #show" do
      get("/username").should route_to("profiles#show", :id => "username")
    end

    it "routes to #edit" do
      get("/username/edit").should route_to("profiles#edit", :id => "username")
    end

    it "routes to #update" do
      put("/username").should route_to("profiles#update", :id => "username")
    end

  end
end
