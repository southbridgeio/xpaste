class QueryGuardMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    env["CONTENT_TYPE"] = "application/octet-stream" if env["PATH_INFO"] == "/paste-file"

    @app.call(env)
  end
end

Rails.application.config.middleware.insert_before Rack::Runtime, QueryGuardMiddleware
