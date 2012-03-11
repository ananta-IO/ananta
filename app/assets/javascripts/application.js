// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.16.custom.min.js
//= require underscore
//= require sugar-1.1.3.min.js
//= require backbone
//= require backbone-relational
//= require backbone_rails_sync
//= require backbone_datalink
//= require bootstrap
//= require jquery.tokeninput
//= require hamlcoffee
//= require backbone/ananta
//= require jquery.isotope.min
//= require jquery.uniform

// Jquery FileUpload
//= require 'jQUpload/tmpl.js'
//= require 'jQUpload/load-image.js'
//= require 'jQUpload/vendor/jquery.ui.widget.js'
//= require 'jQUpload/jquery.iframe-transport.js'
//= require 'jQUpload/jquery.fileupload.js'
//= require 'jQUpload/jquery.fileupload-ui.js'

//= require wait
//= require date

//= require_tree .

// Remove flash after a few seconds
$(window).load(function() {
	$('#flash .alert').show('fade', {}, 1000).delay(8000).slideUp(500);
});

// Stop dropdowns from closing when input field clicked
$('.dropdown input').bind('click', function (e) {
	e.stopPropagation();
})