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
//= require rails-ujs
//= require activestorage
//= require_tree .
//= require decidim

$(document).on("ready page:load", function() {
  // Aspetta un micro-secondo che il componente DisplayConditions sia inizializzato
  setTimeout(function() {
    // Cerca tutte le domande condizionali e forza il check
    $("[data-condition]").each(function() {
      const questionId = $(this).data("condition");
      $(`.question[data-question-id='${questionId}']`).find("input, select, textarea").first().trigger("change");
    });
  }, 100);
});