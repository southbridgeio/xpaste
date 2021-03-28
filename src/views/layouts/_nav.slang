ul.list-lang
  - active = context.locale == I18n.default_locale ? "active" : ""
  li class="list-lang__item #{active}"
    a.list-lang__link.js-change-lang href="#{current_path(locale: "ru")}" | Ru
  - active = context.locale == "en" ? "active" : ""
  li class="list-lang__item #{active}"
    a.list-lang__link.js-change-lang href="#{current_path(locale: "en")}" En