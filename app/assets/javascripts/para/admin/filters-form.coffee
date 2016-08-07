class FiltersForm
  constructor: (options = {}) ->
    @$el = options.$el
    @$el.on('change', 'input, select', @onChange)

  onChange: =>
    @$el.submit()

$(document).on 'page:change turbolinks:load', ->
  $('[data-filters-form]').each (i, el) ->
    new FiltersForm($el: $(el))
