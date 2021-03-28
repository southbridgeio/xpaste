require "./spec_helper"

describe ApplicationController do
  describe "GET #healthcheck" do
    it "renders healthcheck page" do
      get "/health"
      status_code.should eq 200
      json_body.should match({ "status" => "OK" })
    end
  end

  describe "GET #error" do
    it "renders error page" do
      get "/error"
      status_code.should eq 500
      json_body.should match({ "status" => "FAILED", "description" => "test xpaste error" })
    end
  end

  describe "GET #html_error" do
    it "render oops page" do
      get "/html_error"
      status_code.should eq 500
      body.should contain "Упс, случилось что-то непредвиденное"
    end
  end
end
