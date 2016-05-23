# Tabs hash management adapted from SO answer :
#   http://stackoverflow.com/a/21443271/685925
#
class Para.Tabs
  constructor: (options = {}) ->
    @$el = $(options.el)
    @showActiveTab()
    @$('a[data-toggle="tab"]').on('shown.bs.tab', @onTabShown)

  showActiveTab: ->
    @$('a[href="' + location.hash + '"]').tab('show') if location.hash isnt ''

  onTabShown: (e) =>
    tabHash = $(e.target).attr('href').substr(1)
    history.pushState(null, null, "##{ tabHash }")

  $: (args...) ->
    $.fn.find.apply(@$el, args)

$(document).on 'page:change', ->
  $('[data-form-tabs]').each (i, el) -> new Para.Tabs(el: el)
