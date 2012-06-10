require "spec_helper"

describe SessionsController do
  describe "routing" do

    it "routes to #index" do
      get("/sessions").should route_to("sessions#index")
    end

  end
end
