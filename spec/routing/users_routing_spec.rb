require "spec_helper"

describe UsersController, routing: true, slow: true do
  describe "routing" do

    it "routes to #index" do
      get("/users").should route_to("users#index")
    end

  end
end