- if paste.auto_destroy? && params[:destroy]?.nil?
  == render(partial: "_auto_destroy.slang")
- else
  .code_wrap
    == render(partial: "_header.slang")

    == render(partial: "_body.slang")

    - if paste.auto_destroy?
        .destroyed
          img src="/images/trash.svg"
          == t("pastes.show.paste_destroyed")