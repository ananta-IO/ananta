require "spec_helper"

describe AnswersController, routing: true, slow: true do
  describe "routing" do

    it "routes to #index" do
      get("/questions/q_id/answers").should route_to("answers#index", :question_id => "q_id")
    end

    it "routes to #show" do
      get("/questions/q_id/answers/1").should route_to("answers#show", :question_id => "q_id", :id => "1")
    end

    it "routes to #create" do
      post("/questions/q_id/answers").should route_to("answers#create", :question_id => "q_id")
    end

    it "routes to #update" do
      put("/questions/q_id/answers/1").should route_to("answers#update", :question_id => "q_id", :id => "1")
    end

  end
end
