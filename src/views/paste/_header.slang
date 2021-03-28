.header
  strong == t("activerecord.attributes.paste.language") + ": "
    == @language
  br
  strong == t("activerecord.attributes.paste.created_at") + ": "
    - if context.locale == "ru"
      == paste.created_at.not_nil!.to_s("%d.%m.%Y, %H:%M UTC")
    - else
      == paste.created_at.not_nil!.to_s("%Y-%m-%d %I:%M %P UTC")
  br
  strong == t("activerecord.attributes.paste.will_be_deleted_at") + ": "
    - if context.locale == "ru"
      == paste.will_be_deleted_at.not_nil!.to_s("%d.%m.%Y, %H:%M UTC")
    - else
      == paste.will_be_deleted_at.not_nil!.to_s("%Y-%m-%d %I:%M %P UTC")
  br
  br

  .box-field__input
    input.form-control value="#{root_url}/p/#{paste.permalink}" id="url" readonly="readonly"

    button.btn.clipboard data-clipboard-target="#url" title="#{t("pastes.form.btn_copy_hint")}" data-msg="#{t("pastes.form.btn_copy_msg")}"
      i.fas.fa-copy.fa-2x

    a.btn href="#{root_url}/p/#{paste.permalink}?raw" title="RAW" RAW

  br
