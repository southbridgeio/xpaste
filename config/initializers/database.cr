require "granite/adapter/pg"

if env_config = ENV.fetch("DATABASE_URL", nil)
  database_url = env_config
end

if db_host = ENV.fetch("DB_HOST", nil)
  db_name = ENV.fetch("DB_NAME", "")
  db_port = ENV.fetch("DB_PORT", "")
  db_user = ENV.fetch("DB_USER", "")
  db_password = ENV.fetch("DB_PASSWORD", "")
  db_password = ":#{db_password}" if db_password && db_password != ""
  database_url = "postgres://#{db_user}#{db_password}@#{db_host}:#{db_port}/#{db_name}"
end

Granite::Connections << Granite::Adapter::Pg.new(name: "pg", url: database_url || Amber.settings.database_url)
