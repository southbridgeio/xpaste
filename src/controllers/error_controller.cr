class Amber::Controller::Error < Amber::Controller::Base
  include ApplicationHelper
  include JasperHelpers
  include UrlHelpers
  include AssetHelpers

  def not_found
    response.status_code = 404
    render("404.slang")
  end

  def internal_server_error
    render("500.slang")
  end
end
