class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes


  def healthcheck
    begin
      Paste.count
    rescue
      raise "Database connection is missing"
    end

    render json: { status: "OK" }
  rescue StandardError => ex
    Airbrake.notify(ex)
    render json: { status: "FAILED", description: ex.message }, status: 500
  end

  def error
    raise "test xpaste error"
  rescue StandardError => ex
    Airbrake.notify(ex)
    render json: { status: "FAILED", description: ex.message }, status: 500
  end

  def html_error
    raise Exception.new "test xpaste error"
  end
end
