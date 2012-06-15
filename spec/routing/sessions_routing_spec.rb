require "spec_helper"

describe SessionsController, routing: true, slow: true do
  describe "routing" do

    it "routes to #index" do
      get("/sessions").should route_to("sessions#index")
    end

  end
end
