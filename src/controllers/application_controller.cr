require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  include UrlHelpers
  include AssetHelpers

  LAYOUT = "application.slang"

  def healthcheck
    response.headers["content-type"] = "application/json"
    begin
      Paste.all("LIMIT 1").size
    rescue
      raise "Database connection is missing"
    end

    {"status": "OK"}.to_json
  rescue ex
    Airbrake.notify(ex)
    response.status_code = 500
    {"status": "FAILED", "description": ex.message}.to_json
  end

  def error
    raise "test xpaste error"
  rescue ex
    Airbrake.notify(ex)
    response.status_code = 500
    response.headers["content-type"] = "application/json"
    {"status": "FAILED", "description": ex.message}.to_json
  end

  def html_error
    raise Exception.new "test xpaste error"
  end
end
