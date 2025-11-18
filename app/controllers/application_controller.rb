class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

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
    render json: { status: "FAILED" }, status: 500
  end

  def html_error
    raise Exception.new "test xpaste error"
  end

  def error_404
    render "errors/404", status: :not_found
  end

  def error_500
    respond_to do |format|
      format.html { render "errors/500", status: :internal_server_error }
      format.any { render plain: "Внутренняя ошибка сервера" }
    end
  end
end
