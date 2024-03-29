/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import 'bootstrap/dist/js/bootstrap';
import 'ace-builds';
import 'ace-builds/webpack-resolver';
import 'leaflet/dist/leaflet';
import 'leaflet-iiif/leaflet-iiif';
import 'leaflet-draw/dist/leaflet.draw';

// Import TinyMCE
import tinymce from 'tinymce/tinymce';
// Default icons are required for TinyMCE 5.3 or above
import 'tinymce/icons/default';
// A theme is also required
import 'tinymce/themes/silver';
import 'tinymce/plugins/code';

require("@rails/ujs").start()
require("@rails/activestorage").start()

// Following advice from https://stackoverflow.com/questions/57555708/rails-6-how-to-add-jquery-ui-through-webpacker
global.$ = require("jquery")
require("jquery-ui")

// Local
require('blacklight-frontend/app/javascript/blacklight/core')
require('blacklight-frontend/app/javascript/blacklight/autocomplete')
require('blacklight-frontend/app/javascript/blacklight/checkbox_submit')
require('blacklight-frontend/app/javascript/blacklight/modal')
require('blacklight-frontend/app/javascript/blacklight/bookmark_toggle')
require('blacklight-frontend/app/javascript/blacklight/button_focus')
require('blacklight-frontend/app/javascript/blacklight/facet_load')
require('blacklight-frontend/app/javascript/blacklight/search_context')
// doing the above rather than require('blacklight-frontend/app/assets/javascripts/blacklight/blacklight')
// each script may have an import it's doing

// Removed from _home_text.html.erb
Blacklight.onLoad(function() {
    $('#about .card-header').one('click', function() {
        $($(this).data('target')).load($(this).find('a').attr('href'));
    });
});
