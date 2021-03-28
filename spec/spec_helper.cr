ENV["CRYSTAL_ENV"] ||= "test"
ENV["AMBER_ENV"] ||= "test"

require "spec"
require "micrate"
require "timecop"

require "../config/*"

Micrate::DB.connection_url = Granite::Connections.registered_connections.find { |adapter| adapter.name == "pg" }.not_nil!.url

# Automatically run migrations on the test database
Micrate::Cli.run_up
