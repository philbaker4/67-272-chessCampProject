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
//= require rails-ujs
//= require materialize-sprockets
//= require materialize-form
//= require vue
//= require Chart.bundle
//= require chartkick
//= require_tree .


$( document ).ready(function () {
    $('select').material_select();
    $('.datepicker').pickadate({
    format: 'mmmm dd, yyyy',
    formatSubmit: 'mmmm dd, yyyy',
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 15, // Creates a dropdown of 15 years to control year,
    today: 'Today',
    clear: 'Clear',
    close: 'Ok',
    closeOnSelect: false // Close upon selecting a date,
  });
});


// Flash fade
$(function() {
   $('.alert-box').fadeIn('normal', function() {
      $(this).delay(3700).fadeOut();
   });
});
