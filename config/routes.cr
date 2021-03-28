Amber::Server.configure do
  crom = Crometheus::Middleware::HttpCollector.new(Crometheus.default_registry, ->(path: String){ path.gsub(%r{/p/[0-9a-zA-Z]+$}, "/p/:id")})
  Crometheus.default_registry.path = "/metrics"
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    plug crom
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
#    plug Amber::Pipe::CSRF.new
  end

  pipeline :api do
    plug crom
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    # plug Amber::Pipe::CORS.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug crom
    plug Crometheus.default_registry.get_handler
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new(public_dir="./public", fallthrough=true)
  end

  routes :web, "/(:locale)" do
    get "/health", ApplicationController, :healthcheck
    get "/error", ApplicationController, :error
    get "/html_error", ApplicationController, :html_error
    resources "/p", PasteController, only: [:new, :create, :show]
    get "/help", PasteController, :help
    get "/policy", PasteController, :privacy_policy
    get "/", PasteController, :new
  end

  routes :api do
    post "/paste", PasteController, :create
    post "/paste-file", PasteController, :create_from_file
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", Amber::Controller::Static, :index
  end
end
