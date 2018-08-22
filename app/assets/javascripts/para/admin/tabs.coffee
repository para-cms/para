# Tabs hash management adapted from SO answer :
#   http://stackoverflow.com/a/21443271/685925
#
class Para.Tabs extends Vertebra.View
  events:
    'shown.bs.tab a[data-toggle="tab"]': 'onTabShown'
    'change .tab-pane': 'onFormInputUpdate'

  initialize: (options = {}) ->
    @$anchorInput = options.$anchorInput
    @showActiveTab()
    @refreshTabsErrors()
    @initializeAffix()

  showActiveTab: ->
    if (hash = (location.hash or @$anchorInput?.val()))
      @findTab(hash).tab('show')

  onTabShown: (e) =>
    $tab = $(e.target)
    return unless $tab.closest('[data-form-tabs]').is('[data-top-level-tabs]')

    tabHash = $tab.attr('href')
    history.pushState(null, null, tabHash)
    @updateAnchorInput()

  updateAnchorInput: ->
    @$anchorInput.val(location.hash) if @$anchorInput.length

  refreshTabsErrors: ->
    @$('[data-toggle="tab"]').each (i, tab) =>
      @refreshTabErrors($(tab))

  refreshTabErrors: ($tab) ->
    $panel = @$($tab.attr('href'))
    $tab.addClass('has-error') if $panel.find('.has-error').length

  #
  initializeAffix: ->
    return unless (@$nav = @$('[data-tabs-nav-affix]')).length

    headerHeight = $('[data-header]').outerHeight()
    offsetTop = @$nav.offset().top - headerHeight
    sidebarWidth = $('[data-admin-left-sidebar]').outerWidth()

    @$nav.affix(offset: { top: offsetTop })
         .css(top: headerHeight, left: sidebarWidth)

    # Fix parent wrapper height to maintain the same scroll position when the
    # nav tabs are fixed to top
    @$nav.closest('[data-nav-tabs-wrapper]').height(@$nav.outerHeight())

  onFormInputUpdate: (e) ->
    $tab = @findTab($(e.currentTarget).attr('id'))
    @refreshTabErrors($tab)

  findTab: (id) ->
    id = "##{ id }" unless id.indexOf('#') >= 0
    @$('a[href="' + id + '"]')

$(document).on 'page:change turbolinks:load', ->
  $('[data-form-tabs]').each (i, el) ->
    new Para.Tabs(el: el, $anchorInput: $('[data-current-anchor]'))
