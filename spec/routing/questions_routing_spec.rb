require "spec_helper"

describe QuestionsController do
  describe "routing" do

    it "routes to #index" do
      get("/questions").should route_to("questions#index")
      get("/questions/page/1").should route_to("questions#index", :page => '1')
    end

    it "routes to #show" do
      get("/questions/1").should route_to("questions#show", :id => "1")
    end

    it "routes to #create" do
      post("/questions").should route_to("questions#create")
    end

    it "routes to #update" do
      put("/questions/1").should route_to("questions#update", :id => "1")
    end

  end
end
