require "./spec_helper"

describe Amber::Controller::Error do
  describe "GET #not_found" do
    it "renders not found page" do
      get "/something_strange"
      status_code.should eq 404
      body.should contain "Такой страницы уже нет"
    end
  end
  describe "#internal_server_error" do
    it "render oops page on internal server error" do
      post "/paste", form: { body: "\x00", language: "text" }, headers: HTTP::Headers { "Accept" => "text/html" }
      status_code.should eq 500
      body.should contain "Упс, случилось что-то непредвиденное"
    end
  end
end
