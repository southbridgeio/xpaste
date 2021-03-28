class PasteController < ApplicationController
  getter paste = Paste.new
  @body = String.new
  @development : Bool? = Amber.env.development?
  @ex = Exception.new

  before_action do
    only [:show] { set_paste }
    all { set_locale }
  end

  def show
    @language = paste.language
    @body = paste.body.to_s

    if paste.language == "markdown"
      if @body.size <= 100000
        options = Markd::Options.new(smart: false, safe: true)
        begin
          document = Markd::Parser.parse(paste.body.to_s, options)
          renderer = Markd::CustomRenderer.new(options)
          @body = renderer.render(document)
        rescue
          #
        end
      else
        @language = "text"
      end
    end

    if params[:raw]?
      body = paste.body
      response.headers["content-type"] = "text/plain; charset=UTF-8"
      paste.destroy if paste.auto_destroy?
      return body
    else
      template = render "show.slang"

      if destroy = params[:destroy]? && paste.auto_destroy?
        paste.destroy if destroy.to_s == "true"
      end

      template
    end
  end

  def new
    render "new.slang"
  end

  def help
    render "help.slang"
  end

  def privacy_policy
    render "privacy_policy.slang"
  end

  def create
    unless paste_params.valid?
      response.status_code = 422

      return respond_with 500 do
        json "errors": paste_params.errors.map {|e| e.message}.join(", ")
      end
    end

    paste = Paste.new paste_params.validate!
    paste.auto_destroy = params[:auto_destroy]? ? params[:auto_destroy].to_s != "false" : false
    paste.ttl_days = params[:ttl_days]? ? params[:ttl_days] : Paste::DEFAULT_TTL_DAYS

    token = Paste.generate_token
    while Paste.exists?(permalink: token)
      token = Paste.generate_token
    end
    paste.permalink = token

    begin
      paste.save!       # Will throw an exception when the save failed
      url = "/p/#{paste.permalink}"
      url = "/#{context.locale}#{url}" if I18n.default_locale != context.locale

      if request.headers["Accept"].to_s.split(',').includes?("text/html")
        redirect_to(url)
      else
        respond_with do
          html "#{base_url}#{url}"
          text "#{base_url}#{url}"
          json paste.to_json
        end
      end
    rescue ex
      Airbrake.notify(ex)

      respond_with 500 do
        html render "error/500.slang"
        json paste.to_json
      end
    end
  rescue ex
    Airbrake.notify(ex)

    raise ex
  end

  def create_from_file

    begin
      request.body.not_nil!
    rescue
      return respond_with 500 { text "invalid body" }
    end

    request_body = request.body.not_nil!
    request_body.set_encoding("utf-8", nil)
    request_body = request_body.gets_to_end

    max_size = 5 * 1024 * 1024
    if request_body.size > max_size
      cut_message = "\nText was automatically cut over 5 mb"
      request_body = request_body[0, max_size - cut_message.size] + cut_message
    end

    unless request_body.valid_encoding?
      args = [
        "-c",
        "echo \"#{request_body}\" | enconv -cL russian -x utf8"
      ]
      code, request_body = run_cmd("/bin/sh", args)

      return respond_with 500 { text "invalid encoding" } if code.to_i != 0
    end

    paste = Paste.new
    paste.body = request_body
    paste.language = params[:language]
    paste.auto_destroy = params[:auto_destroy]? ? params[:auto_destroy].to_s != "false" : false
    paste.ttl_days = (params[:ttl_days]? && params[:ttl_days].to_i > 0) ? params[:ttl_days] : Paste::DEFAULT_TTL_DAYS
    token = Paste.generate_token
    while Paste.exists?(permalink: token)
      token = Paste.generate_token
    end

    paste.permalink = token
    begin
      paste.save!       # Will throw an exception when the save failed
      respond_with{ text "#{base_url}/p/#{paste.permalink}" }
    rescue ex
      Airbrake.notify(ex)
      respond_with 500 { text paste.errors.map{|e| return e.to_s }.join("; ") }
    end
   rescue ex
     Airbrake.notify(ex)

     raise ex
  end

  private def paste_params
    params.validation do
      required(:body) { |p| p.str? }
      required(:language) { |p| p.str? }
      optional(:auto_destroy) { |p| p.str? }
      optional(:ttl_days) { |p| p.str? }
    end
  end

  private def set_paste
    @paste = Paste.find_by!(permalink: params[:id])
  rescue
    raise Amber::Exceptions::RouteNotFound.new(request)
  end

  private def set_locale
    if params_locale = context.params["locale"]?
      parser = Citrine::I18n::Parser.new params_locale
      compat = parser.compatible_language_from ::I18n.available_locales if parser

      if compat
        context.locale = compat
      else
        context.locale = "ru"
        raise Amber::Exceptions::RouteNotFound.new(context.request)
      end
    else
      context.locale = ::I18n.default_locale
    end
  end

  private def run_cmd(cmd, args)
    stdout = IO::Memory.new
    stderr = IO::Memory.new
    status = Process.run(cmd, args: args, output: stdout, error: stderr)
    if status.success?
      {status.exit_code, stdout.to_s}
    else
      {status.exit_code, stderr.to_s}
    end
  rescue
    { -1 , "" }
  end
end
