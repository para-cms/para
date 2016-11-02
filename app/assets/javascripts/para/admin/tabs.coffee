# Tabs hash management adapted from SO answer :
#   http://stackoverflow.com/a/21443271/685925
#
class Para.Tabs extends Vertebra.View
  events:
    'shown.bs.tab a[data-toggle="tab"]': 'onTabShown'

  initialize: (options = {}) ->
    @$anchorInput = options.$anchorInput
    @showActiveTab()

  showActiveTab: ->
    if (hash = location.hash or @$anchorInput?.val())
      @$('a[href="' + hash + '"]').tab('show')

  onTabShown: (e) =>
    tabHash = $(e.target).attr('href').substr(1)
    history.pushState(null, null, "##{ tabHash }")
    @updateAnchorInput(tabHash)

  updateAnchorInput: ->
    @$anchorInput.val(location.hash) if @$anchorInput.length


$(document).on 'page:change turbolinks:load', ->
  $('[data-form-tabs]').each (i, el) ->
    new Para.Tabs(el: el, $anchorInput: $('[data-current-anchor]'))
