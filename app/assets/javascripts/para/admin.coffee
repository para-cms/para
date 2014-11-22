#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require jquery.mCustomScrollbar.min
#= require selectize
#= require jquery.jcrop
#= require papercrop
#= require jasny.bootstrap.min
#= require simple_form_extension
#= require jquery.scrollto
#= require html5-sortable
#= require s3_direct_upload
#= require cocoon
#= require_self
#= require_tree ./lib
#= require_tree ./inputs
#= require_tree ./admin

# Initialize scope
window.Para = {}

$(document).on 'page:change', ->
  $('.selectize').selectize()
  init_papercrop()

$(document).on 'page:change', ->
  $("#s3-uploader").S3Uploader()
