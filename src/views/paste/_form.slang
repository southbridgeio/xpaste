.box-form
  == form(action: "#{root_path}p/#{paste.permalink.to_s}", method: paste.id ? :patch : :post, class: "formats-form") do

    .box-formats
      .formats-choice
        ul.formats-choice__list
          li class="formats-choice__item formats-choice__item js-formats-choice"
            button.button.button1.active = t("pastes.form.formats.text")
            button.button.button2 = t("pastes.form.formats.password")
            button.button.button3 = t("pastes.form.formats.code")
            .format_select
              p #{t("activerecord.attributes.paste.language")}:
              select#paste_language name="language"
                - Paste::LANGUAGE.each do |lang|
                  option value="#{lang.to_s}" == lang.to_s
        .formats-form__text
          == text_area name: "body", content: "", autofocus: true, id: "paste_body", class: "formats-form__textarea", rows: "5", "data-widearea": "enable", required: "required"
      .formats-create
        .formats-create__item
          .formats-create__remove
            label for="days"
              span == t("activerecord.attributes.paste.ttl_days")
              span.remove-days
                input.formats-create__days.js-formats-create__days type="text" id="days" value="#{Paste::DEFAULT_TTL_DAYS}" name="ttl_days" required=""
              span == t("activerecord.attributes.paste.days")
          .formats-create__remove
            label.formats-create__label
              input.formats-create__check type="checkbox" name="auto_destroy"
              span.label-text == t("activerecord.attributes.paste.auto_destroy")
        .formats-create__item
          .btn-box
            == submit(t("pastes.form.create"), class: "button")
