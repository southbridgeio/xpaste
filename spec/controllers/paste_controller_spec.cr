require "./spec_helper"

describe PasteController do
  describe "GET #new" do
    it "renders main page" do
      get "/"
      status_code.should eq 200
      body.should contain "Упакуем пароль или код в cсылку для передачи"
    end
  end

  describe "GET #help" do
    it "renders help page" do
      get "/help"
      status_code.should eq 200
      body.should contain "Справка"
    end
  end

  describe "GET #privacy_policy" do
    it "renders privacy policy page" do
      get "/policy"
      status_code.should eq 200
      body.should contain "Настоящим уведомляем вас"
    end
  end

  describe "GET #create" do
    paste_body = "Test"

    it "creates paste" do
      post "/paste", form: { body: paste_body, language: "text" }, headers: HTTP::Headers { "Accept" => "text/html" }
      status_code.should eq 302
      Paste.count.should eq 1
      Paste.limit(1).assembler.first.first.body.should eq paste_body
    end

    context "when format is json" do
      it "creates paste and renders it as json" do
        post "/paste", form: { body: paste_body, language: "text" }, headers: HTTP::Headers { "Accept" => "application/json" }
        paste = Paste.limit(1).assembler.first.first
        status_code.should eq 200
        json_body.should contain({ "permalink" => paste.permalink })
      end
    end
  end
  describe "POST #create_from_file" do
    paste_body = "File post test"

    it "creates paste from file" do
      post "/paste-file?language=text", body: paste_body
      status_code.should eq 200
      body.should contain "/p/"
      Paste.count.should eq 1
      Paste.limit(1).assembler.first.first.body.should eq paste_body
    end

    it "return errors in plain text on saving failure" do
      post "/paste-file?language=text", body: "\x00"
      status_code.should eq 200
      body.should_not contain "/p/"
      body.should contain "invalid byte"
      Paste.count.should_not eq 1
    end
  end
  describe "GET #show" do
    paste_body = "show test"

    it "can show paste" do
      post "/paste", form: { body: paste_body, language: "text" }, headers: HTTP::Headers { "Accept" => "text/html" }
      get "/p/#{Paste.limit(1).assembler.first.first.permalink}"
      status_code.should eq 200
      body.should contain paste_body
    end

    context "when raw paste requested" do
      it "can show raw paste" do
        post "/paste", form: { body: paste_body, language: "text" }, headers: HTTP::Headers { "Accept" => "text/html" }
        get "/p/#{Paste.limit(1).assembler.first.first.permalink}?raw"
        status_code.should eq 200
        body.should eq paste_body
      end
    end
  end
end
