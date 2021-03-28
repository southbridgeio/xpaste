doctype html
html
  head
    title xPaste
    meta charset="utf-8"
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1"
    link rel="stylesheet" href="#{asset_path("style.css")}"
    link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.1/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous"
    link rel="icon" type="image/x-icon" href="/favicon.ico"
    javascript:
      (function (i, s, o, g, r, a, m) {
        i['GoogleAnalyticsObject'] = r;
        i[r] = i[r] || function () {
                (i[r].q = i[r].q || []).push(arguments)
            }, i[r].l = 1 * new Date();
        a = s.createElement(o),
            m = s.getElementsByTagName(o)[0];
        a.async = 1;
        a.src = g;
        m.parentNode.insertBefore(a, m)
      })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');

      ga('create', 'UA-89632404-1', 'auto');
      ga('send', 'pageview');


  body.loaded.hide-instruction
    .main-wrapper
      main.content
        .wrapper
          == content

      header
        .wrapper
          .box-header
            .box-header__left
              .logo
                a.logo__link href="#{root_url}" xPaste
              .header-title
                h1 == t("leadline")

            .box-header__right
              .box-lang
                == render(partial: "layouts/_nav.slang")

      footer.footer
        .wrapper
          .box-footer
            .footer__item
              span == t("copyright")
                a href="https://southbridge.io" Southbridge
            .footer__item.footer__item_links
              a href="#{help_path}" == t("help")
              a href="#{privacy_policy_path}" == t("privacy_policy")

    script src="#{asset_path("main.js")}"
    - if Amber.settings.auto_reload?
      script src="/js/client_reload.js"
