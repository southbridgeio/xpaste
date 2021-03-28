div.help
  h1.title == t("help")

  p == t("pastes.help.contact_with_us")
    |: ask@southbridge.io /
    a href="https://southbridge.io" target="_blank" www.southbridge.io

  p == t("pastes.help.open_page")
  p == t("pastes.help.open_page_raw")

  p #{t("pastes.help.create_method.title")}:

  ul
    li #{t("pastes.help.create_method.form")};
    li #{t("pastes.help.create_method.text_post")};
    li #{t("pastes.help.create_method.json_post")}.

  div #{t("pastes.help.post_address")}:
    code == "#{root_url}/paste"
  p #{t("pastes.help.available_params")}:
  pre
    | language: text|markdown
    | body: #{t("pastes.help.text_length_limit")} 512 kb
    | auto_destroy: true
    | ttl_days: 365

  ul
    li
      strong body
      | -
      == t("pastes.help.required")
      |.
      == t("pastes.help.max_text_limit")
      | - 512 kb.
    li
      strong language
      == t("pastes.help.one_of_x_values")
      code text
      == t("pastes.help.or")
      code markdown.
      == t("pastes.help.default_language")
      code (text)
      |.
    li
      strong auto_destroy
      == t("pastes.help.auto_destroy")
    li
      strong ttl_days
      == t("pastes.help.ttl_days")

  br
  h2.title == t("pastes.help.text_examples")

  p == t("pastes.help.short_text")
    |:

  pre curl -d "language=text" -d "body=short text message" "#{root_url}/paste"
  pre curl -d "language=text" -d "body=short text message" -d "ttl_days=17" "#{root_url}/paste"
  pre curl -d "language=markdown" -d "body=**Markdown** _text_ message" "#{root_url}/paste"
  pre curl -d "auto_destroy=true" -d "language=markdown" -d "body=**Markdown** _text_ message" "#{root_url}/paste"
  br
  h3.title == t("pastes.help.file_sending")
  p == t("pastes.help.long_text")
    |:

  pre curl -H "Content-Type: text/plain" --data-binary "@file_name" "#{paste_file_url(language: "markdown")}"

  p
    strong == t("pastes.help.long_text_cut")

  p == t("pastes.help.ttl_days_example")
    |:paste_file_path

  pre curl -H "Content-Type: text/plain" --data-binary "@file_name" #{paste_file_url(language: "markdown", ttl_days: 7)}

  p #{t("pastes.help.auto_destroy_example")}:

  pre curl -H "Content-Type: text/plain" --data-binary "@file_name" #{paste_file_url(language: "markdown", auto_destroy: true)}
  br
  h2.title == t("pastes.help.json_request")
  pre curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST  \\
    | -d '{"language":"text","body":"text"}' "#{root_url}/paste"

  br
  br
  br
