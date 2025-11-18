import jQuery from "jquery";
window.$ = window.jQuery = jQuery;

$(window).on("load", function () {
  if (/Android|webOS|iPad|iPod|BlackBerry/i.test(navigator.userAgent)) {
    $("body").addClass("ios");
  } else if (/iPhone/i.test(navigator.userAgent)) {
    $("body").addClass("iph");
  } else {
    $("body").addClass("web");
  }

  var viewport_wid = viewport().width;
  var wrp_w = $(".wrapper").width();
  var formats_form_w = $(".formats-form").width();
  var choices;

  $(".js-input").css("max-width", formats_form_w);
  $(".cont-instruction").width((viewport_wid - wrp_w) / 6 + 300);
  $("body").removeClass("loaded");

  if ($("#paste_language").length) {
    choices = new Choices($("#paste_language")[0], { itemSelectText: "" });
  }

  var clipboard = new ClipboardJS(".clipboard");

  clipboard.on("success", function (e) {
    e.clearSelection();
    e.trigger.setAttribute(
      "class",
      "btn tooltipped tooltipped-s tooltipped-no-delay"
    );
    e.trigger.setAttribute("aria-label", $(e.trigger).data("msg"));
  });

  var clipboardEl = $(".clipboard");

  clipboardEl.on("mouseleave", clearPopup);
  clipboardEl.on("blur", clearPopup);

  wideArea();

  $("textarea")
    .each(function () {
      autosize(this);
    })
    .on("autosize:resized", function () {
      $(".widearea-wrapper")[0].style.height = null;
    });

  $("button.button").on("click", function (e) {
    e.preventDefault();

    $("ul.formats-choice__list button").removeClass("active");
    let targetEl = $(e.target);
    targetEl.addClass("active");

    if (targetEl.hasClass("button1")) {
      $("#days").val(30);
      $('input[name="auto_destroy"]').prop("checked", false);
      $(".format_select").css("visibility", "hidden");
      choices.setValue(["text"]);
    }

    if (targetEl.hasClass("button2")) {
      $("#days").val(7);
      $('input[name="auto_destroy"]').prop("checked", true);
      $(".format_select").css("visibility", "hidden");
      choices.setValue(["text"]);
    }

    if (targetEl.hasClass("button3")) {
      $("#days").val(30);
      $('input[name="auto_destroy"]').prop("checked", false);
      $(".format_select").css("visibility", "visible");
    }
  });
});

function clearPopup(e) {
  e.currentTarget.setAttribute("class", "btn");
  e.currentTarget.removeAttribute("aria-label");
}

/* viewport width */
function viewport() {
  var e = window,
    a = "inner";
  if (!("innerWidth" in window)) {
    a = "client";
    e = document.documentElement || document.body;
  }
  return { width: e[a + "Width"], height: e[a + "Height"] };
}

/* viewport width */
$(function () {
  /*Tooltip*/
  $(".js-statistics-table-remove").click(function () {
    $(this).addClass("active");
    $(this).parent().find(".statistics-table__tooltip").addClass("active");
    $(this).closest(".statistics-table__item").addClass("hide-link");
    return false;
  });
  $(".js-cancel").click(function () {
    $(this).parent(".statistics-table__tooltip").removeClass("active");
    $(this).parents(".statistics-table__item").removeClass("hide-link");
    return false;
  });

  /*Remove link*/
  $(".js-remove-link").click(function () {
    $(this).closest(".statistics-table__item").remove();
    return false;
  });

  /*Restore link*/
  $(".restore-link").click(function () {
    $(".js-statistics-table-remove").removeClass("active");
    $(this).parent().removeClass("active");
    return false;
  });

  $(".js-more-title").click(function () {
    $(this).toggleClass("active").next().toggleClass("active");
    return false;
  });

  $(".js-formats-create__days").keyup(function (event) {
    if (this.value.match(/[^0-9]/g)) {
      this.value = this.value.replace(/[^0-9]/g, "");
    }
  });

  $(document).on("touchstart click", function (e) {
    if (
      $(e.target).parents().filter(".formats-choice__more:visible").length != 1
    ) {
      $(".formats-choice__more").removeClass("active");
    }
  });

  if ($(".js-input").length) {
    $(".js-input").autosizeInput();
  }
});
