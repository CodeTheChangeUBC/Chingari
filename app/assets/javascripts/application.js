// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require popper
//= require wow
//= require owl.carousel

//= require bootstrap
//= require rails-ujs
//= require turbolinks

//= require anchor_scroller


// Turbolinks initial-dom-loaded
$(document).on("turbolinks:load", () => {
  AnchorScroller.scrollToCurrentAnchor(200, 500)

  // Block anchor-jumps when the destination is on current page
  $("a").click(AnchorScroller.overrideAnchorClick);
});

// Turbolink cached-page
$(document).on("turbolinks:visit", () => {
  AnchorScroller.scrollToCurrentAnchor(200, 500)
});