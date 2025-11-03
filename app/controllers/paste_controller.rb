class PasteController < ApplicationController
  MAX_MARKDOWN_SYMBOLS = 100000
  MAX_FILE_SIZE = 5 * 1024 * 1024

  before_action :set_locale
  before_action :build_paste
  before_action :set_paste, only: :show
  skip_before_action :verify_authenticity_token, only: [:create_from_file]

  def show
    @language = @paste.language
    @body = @paste.body.to_s
    @highlight = !(params[:highlight] == "false")

    if params[:raw]
      @paste.destroy if @paste.auto_destroy?
      return render plain: @body
    end

    if @paste.language == "markdown" && @body.size <= 100000
      if @body.size <= MAX_MARKDOWN_SYMBOLS
        @body = @paste.to_markdown
        @highlight = false
      else
        @language = "text"
      end
    end

    @paste.destroy if @paste.auto_destroy? && params[:destroy] == "true"
  end

  def new
  end

  def help
  end

  def privacy_policy
  end

  def create
    @paste = Paste.new(paste_params)
    @paste.auto_destroy = paste_params[:auto_destroy].to_i > 0
    @paste.ttl_days = paste_params[:ttl_days] ? paste_params[:ttl_days].to_i : Paste::DEFAULT_TTL_DAYS
    @paste.permalink = generate_token

    begin
      @paste.save!       # Will throw an exception when the save failed
      url = "/p/#{@paste.permalink}"
      url = "/#{I18n.locale}#{url}" if I18n.default_locale != I18n.locale

      respond_to do |format|
        format.html { redirect_to url }
        format.text { render plain: "#{root_url.chomp('/')}#{url}" }
        format.json { render json: @paste }
      end
    rescue StandardError => ex
      Airbrake.notify(ex)

        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: { errors: @paste.errors.full_messages.join(", ") }, status: :unprocessable_entity }
        end
    end

  rescue StandardError => ex
    Airbrake.notify(ex)

    raise ex
  end

  def create_from_file
    return render plain: "Invalid body", status: :unprocessable_entity if request.body.nil?

    request_body = request.body
    request_body.set_encoding("utf-8", nil)
    request_body = request_body.read

    if request_body.size > MAX_FILE_SIZE
      cut_message = "\nText was automatically cut over 5 mb"
      request_body = request_body[0, MAX_FILE_SIZE - cut_message.size] + cut_message
    end

    unless request_body.valid_encoding?
      safe_body = Shellwords.escape(request_body)
      command = "/bin/sh -c \"echo #{safe_body} | enconv -cL russian -x utf8\""

      safe_body = IO.popen(command, "r") do |io|
        io.read
      end

      return render plain: "Invalid encoding", status: :unprocessable_entity if safe_body.size.zero?
    end

    paste = Paste.new
    paste.body = request_body
    paste.language = params[:language]
    paste.auto_destroy = (params[:auto_destroy] && params[:auto_destroy].to_s != "false") || false
    paste.ttl_days = params[:ttl_days] ? params[:ttl_days].to_i : Paste::DEFAULT_TTL_DAYS
    paste.permalink = generate_token

    begin
      paste.save!       # Will throw an exception when the save failed
      render plain: "#{root_url}/p/#{paste.permalink}\n"
    rescue StandardError => ex
      Airbrake.notify(ex)
      render plain: paste.errors.full_messages.join(", "), status: :unprocessable_entity
    end
  rescue StandardError => ex
    Airbrake.notify(ex)

    raise ex
  end

  private

  def set_locale
    return I18n.locale = I18n.default_locale unless params[:locale].present?

    locale = params[:locale].to_s
    if I18n.available_locales.map(&:to_s).include?(locale)
      I18n.locale = locale
    else
      I18n.locale = "ru"
      raise ActionController::RoutingError, "No route matches [#{request.method}] #{request.path}"
    end
  end

  def paste_params
    params.require(:paste).permit(:body, :language, :auto_destroy, :ttl_days)
  end

  def build_paste
    @paste = Paste.new
  end

  def set_paste
    @paste = Paste.find_by!(permalink: params[:id])
  rescue ActiveRecord::RecordNotFound
    raise ActionController::RoutingError, "Paste not found"
  end

  def generate_token
    token = Paste.generate_token
    while Paste.exists?(permalink: token)
      token = Paste.generate_token
    end
    token
  end
end
