.not_found
  h1.title = t("not_found.title")
  br
  div = t("not_found.desc")
  br
  == link_to t("pastes.show.go_to_root"), "/", class: "button alt_button"

  .image
    img src="/images/robo.svg"