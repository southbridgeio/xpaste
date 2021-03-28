module UrlHelpers
  # TODO: Можно и надо бы организовать пути через макросы
  def current_path(**options : Object)
    params = HTTP::Params.new
    options.to_h.each do |k,v|
      params.add(k.to_s, v.to_s)
    end

    path = "#{context.request.path}"

    if locale = params["locale"]?
      if existing_locale = context.locale
        if existing_locale == I18n.default_locale
          if I18n.default_locale != locale
            path = "/#{locale}#{path}"
          end
        else
          if I18n.default_locale == locale
            path = "#{path}".gsub("/#{existing_locale}/", "/")
          else
            path
          end
        end
      end
    end

    path
  end

  def root_path
    result = "/"
    result = "#{result}#{context.locale}/" if I18n.default_locale != context.locale
    result
  end

  def help_path
    result = "/"
    result = "#{result}#{context.locale}/" if I18n.default_locale != context.locale
    result = "#{result}help"
    result
  end

  def privacy_policy_path
    result = "/"
    result = "#{result}#{context.locale}/" if I18n.default_locale != context.locale
    result = "#{result}policy"
    result
  end

  def root_url
    result = "#{base_url}"
    result = "#{result}/#{context.locale}/" if I18n.default_locale != context.locale
    result
  end

  def paste_file_url(**options : Object)
    "#{base_url}#{paste_file_path(**options)}"
  end

  def paste_url(**options : Object)
    "#{base_url}#{paste_path(**options)}"
  end

  def paste_path(**options : Object)
    params = HTTP::Params.new
    options.to_h.each do |k,v|
      params.add(k.to_s, v.to_s)
    end

    result = "/p/"
    result = "/#{context.locale}#{result}?#{params}" if I18n.default_locale != context.locale
    result
  end

  def paste_file_path(**options : Object)
    params = HTTP::Params.new
    options.to_h.each do |k,v|
      params.add(k.to_s, v.to_s)
    end

    result = "/paste-file"
    result = "#{result}?#{params}" if params.any?
  end

  def base_url
    if nginx_proto = context.request.headers.get?("x-forwarded-proto")
      protocol = nginx_proto.first
    else
      protocol = Amber::Server.instance.scheme
    end
    "#{protocol}://#{context.request.host_with_port}"
  end
end
