class Turbolinks.Form
  constructor: (@$form) ->
    @$form.on('submit', (e) => @submit(e))

  submit: (e) ->
    e.preventDefault()
    @visit(@buildUrl())

  buildUrl: ->
    url  = @$form.attr('action')
    url += if url.indexOf('?') is -1 then '?' else '&'
    url +  @$form.serialize()

  visit: (url) ->
    Turbolinks.visit(url);


$(document).on "submit", "form[method='get']:not([data-no-turboform])", (e) ->
  $form = $(e.currentTarget)
  unless (turboform = $form.data('turboform-instance'))
    turboform = new Turbolinks.Form($form)
    $form.data('turboform-instance', turboform)
    turboform.submit(e)
