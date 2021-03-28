require "./helpers/**"
require "../config/*"
require "micrate"

action = ARGV[0]?
arg = ARGV[1]?

# В кластерном режиме приложение не наследует флаги родительского приложения, поэтому важно чтобы сервер запускался
# без флагов или аргументов.
case action
  when "run", "r"
    if arg
      case arg
        when "cleanup"
          Task::Cleanup.call
        when "mail_test"
          Task::MailTest.call
      end
    end
  when "db"
    if arg
      Micrate::DB.connection_url = Granite::Connections.registered_connections.find { |connection| connection.name == "pg" }.not_nil!.url

      case arg
        when "drop"
          url = Micrate::DB.connection_url.to_s

          uri = URI.parse(url)
          if path = uri.path
            Micrate::DB.connection_url = url.gsub(path, "/#{uri.scheme}")
            name = path.gsub("/", "")
          else
            Log.info { "Could not determine database name" }
          end

          Micrate::DB.connect do |db|
            db.exec "DROP DATABASE IF EXISTS #{name};"
          end
          Log.info { "Dropped database #{name}" }
        when "create"
          begin
            url = Micrate::DB.connection_url.to_s
            name = ""

            uri = URI.parse(url)
            if path = uri.path
              Micrate::DB.connection_url = url.gsub(path, "/#{uri.scheme}")
              name = path.gsub("/", "")
            else
              Log.info { "Could not determine database name" }
            end

            Micrate::DB.connect do |db|
              db.exec "CREATE DATABASE #{name};"
            end
            Log.info { "Created database #{name}" }
          rescue
            Log.warn { "Perhaps database #{name} already created" }
          end
        when "migrate"
          Micrate::Cli.run_up
        else
          Log.fatal { "Unknown DB command: #{arg}" }
      end
    end
  else
    begin
      Amber::Server.start
    rescue ex
      Airbrake.notify(ex)
      raise ex
    end
end
