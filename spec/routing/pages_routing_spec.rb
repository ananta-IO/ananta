require "spec_helper"

describe AnswersController do
  describe "routing" do

    it "routes to #home" do
      get("/").should route_to("pages#home")
    end

    it "routes to #about" do
      get("/about").should route_to("pages#about")
    end

  end
end
