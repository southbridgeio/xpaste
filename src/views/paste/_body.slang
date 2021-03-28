- highlight = params[:highlight]? == "false" ? "no-highlight" : ""
- if @language == "markdown"
  pre class="code #{paste.language} #{highlight}" == @body
- else
  pre class="code #{paste.language} #{highlight}" = @body