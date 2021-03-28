require "airbrake"

Airbrake.configure do |config|
  config.project_id = ENV.fetch("ERRBIT_PROJECT_ID", "")
  config.project_key = ENV.fetch("ERRBIT_PROJECT_KEY", "")

  # Optional, use airbrake endpoint by default
  config.endpoint = ENV.fetch("ERRBIT_HOST", "")
  # Optional, use ["development", "test"] by default
  config.development_environments = ["development", "test"]
end
