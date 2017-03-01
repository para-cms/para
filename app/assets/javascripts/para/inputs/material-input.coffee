$(document).on 'page:change turbolinks:load', ->
  $('body').on 'focusin focusout', 'input, .redactor-editor', (e) ->
    focused = e.type is 'focusin'
    $(e.target).closest('.form-group').toggleClass('focused', focused)
