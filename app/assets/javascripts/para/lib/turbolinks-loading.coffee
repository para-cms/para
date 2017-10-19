class Para.TurbolinksLoading
  start: =>
    @addLoadingMarkup()

  stop: =>
    @removeLoadingMarkup()

  addLoadingMarkup: ->
    $('<div/>', class: 'loading-overlay', 'data-loading-overlay': true)
      .prependTo('body')
    $('<div/>', class: 'loading-spinner', 'data-loading-spinner': true)
      .prependTo('body')

  removeLoadingMarkup: ->
    $('[data-loading-overlay]').remove()
    $('[data-loading-spinner]').remove()

# Global loading manager allowing to
Para.loadingManager = new Para.TurbolinksLoading()

$(document).on('page:fetch', Para.loadingManager.start)

$(document).on 'page:change turbolinks:load', ->
  Para.loadingManager.stop()
  $('body').on('submit', '[data-para-form]:not([data-remote])', Para.loadingManager.start)
