let Choices = require('choices.js');
import hljs from 'highlight.js';
import ClipboardJS from 'clipboard';
import autosize from 'autosize';
let wideArea = require('./widearea.min.js');
import lineNumbers from './highlightjs-line-numbers.js';

$(window).on('load', function() {
  if (/Android|webOS|iPad|iPod|BlackBerry/i.test(navigator.userAgent)) {
    $('body').addClass('ios');
    // $('.js-bg-img').addClass('bg-zoom');
  } else if( /iPhone/i.test(navigator.userAgent) ) {
    $('body').addClass('iph');
  } else {
    $('body').addClass('web');
  }
  var viewport_wid = viewport().width;
  var wrp_w = $('.wrapper').width();
  var formats_form_w = $('.formats-form').width();
  var choices;
  $('.js-input').css('max-width',formats_form_w);
  $('.cont-instruction').width((viewport_wid - wrp_w)/6 + 300);
  $('body').removeClass('loaded');

  if ($('#paste_language').length) {
    choices = new Choices($('#paste_language')[0], { itemSelectText: "" });
  }

  var clipboard = new ClipboardJS('.clipboard');

  clipboard.on('success', function(e) {
    e.clearSelection();
    e.trigger.setAttribute('class','btn tooltipped tooltipped-s tooltipped-no-delay');
    e.trigger.setAttribute('aria-label', $(e.trigger).data('msg'));
  });

  var clipboardEl = $('.clipboard');

  clipboardEl.on('mouseleave', clearPopup);
  clipboardEl.on('blur', clearPopup);

  window.hljs = hljs;

  window.highlightL = function() {
    $('table.hljs-ln tr').removeClass('highlight');

    let hash = $(location).attr('hash');
    if (hash.length) {
      let hlAnchor = parseInt(hash.match(/\d+/));

      if (hlAnchor > 0) {
        let lineNumber = $(`td.hljs-ln-numbers[data-line-number=\"${hlAnchor.toString()}\"]`);

        if (lineNumber.length) {
          lineNumber.closest('tr').addClass('highlight');
        }
      }
    }
  };

  $('pre.code:not(.no-highlight)').each(function(i, block) {
    hljs.highlightBlock(block);
    lineNumbers(window, document);
    hljs.lineNumbersBlock(block);
    window.highlightL();
  });

  $(document).on('click', 'a.hljs-ln-n', function(e) {
    $('table.hljs-ln tr').removeClass('highlight');
    $(e.target).closest('tr').addClass('highlight');
    $('#url').val(window.location.href);
  });

  wideArea.wideArea();

  $('textarea').each(function(){
    autosize(this);
  }).on('autosize:resized', function(){
    $('.widearea-wrapper')[0].style.height = null;
  });

  $('button.button').on('click', function(e) {
    e.preventDefault();

    $('ul.formats-choice__list button').removeClass('active');
    let targetEl = $(e.target);
    targetEl.addClass('active');

    if (targetEl.hasClass('button1')) {
      $('input[name="auto_destroy"]').prop('checked', false);
      $('.format_select').css('visibility', 'hidden');
      choices.setValue(["text"]);
    }

    if (targetEl.hasClass('button2')) {
      $('input[name="auto_destroy"]').prop('checked',true);
      $('.format_select').css('visibility', 'hidden');
      choices.setValue(["text"]);
    }

    if (targetEl.hasClass('button3')) {
      $('input[name="auto_destroy"]').prop('checked', false);
      $('.format_select').css('visibility', 'visible');
    }
  });
});

function clearPopup(e) {
  e.currentTarget.setAttribute('class', 'btn');
  e.currentTarget.removeAttribute('aria-label')
}

/* viewport width */
function viewport(){
  var e = window, a = 'inner';
  if ( !( 'innerWidth' in window ) )
  {
    a = 'client';
    e = document.documentElement || document.body;
  }
  return { width : e[ a+'Width' ] , height : e[ a+'Height' ] }
}

/* viewport width */
$(function(){
  /*Tooltip*/
  $('.js-statistics-table-remove').click(function() {
    $(this).addClass('active');
    $(this).parent().find('.statistics-table__tooltip').addClass('active');
    $(this).closest('.statistics-table__item').addClass('hide-link');
    return false;
  });
  $('.js-cancel').click(function() {
    $(this).parent('.statistics-table__tooltip').removeClass('active');
    $(this).parents('.statistics-table__item').removeClass('hide-link');
    return false;
  });

  /*Remove link*/
  $('.js-remove-link').click(function() {
    $(this).closest('.statistics-table__item').remove();
    return false;
  });

  /*Restore link*/
  $('.restore-link').click(function() {
    $('.js-statistics-table-remove').removeClass('active');
    $(this).parent().removeClass('active');
    return false;
  });

  $('.js-more-title').click(function() {
    $(this).toggleClass('active').next().toggleClass('active');
    return false;
  });

  $('.js-formats-create__days').keyup(function(event){
    if (this.value.match(/[^0-9]/g)) {
      this.value = this.value.replace(/[^0-9]/g, '');
    }
  });

  $(document).on('touchstart click', function(e) {
    if ($(e.target).parents().filter('.formats-choice__more:visible').length != 1) {
      $('.formats-choice__more').removeClass('active');
    }
  });

  if ($('.js-input').length) {
    $('.js-input').autosizeInput();
  }
});

var handler = function(){
  var height_footer = $('footer').height();
  var height_header = $('header').height();

  var viewport_wid = viewport().width;
  var viewport_height = viewport().height;
  // var content_height = $('.content').height();
  var wrp_w = $('.wrapper').width();
  $('.cont-instruction').width((viewport_wid - wrp_w)/6 + 300);
  var formats_form_w = $('.formats-form').width();
  $('.js-input').css('max-width',formats_form_w);

  if (viewport_wid <= 991) {

  }
};

$(window).bind('load', handler);
$(window).bind('resize', handler);


