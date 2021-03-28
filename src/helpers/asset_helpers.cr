module AssetHelpers
  def asset_path(path)
    result = "/#{path}"

    if Amber.env.production?
      manifest = JSON.parse(manifest_file)
      manifest.as_h.each do |key, value|
        if key == path.to_s
          result = value
          break
        end
      end
    end
    return "/dist#{result}"
  end

  def manifest_file
    {{ `cat "#{__DIR__}/../../public/dist/manifest.json" 2>/dev/null || exit 0`.stringify }}
  end
end
