class TurbolinksReloader
  run: (options = {}) ->
    options.keepScrollPosition ?= true

    if options.keepScrollPosition
      $(document).one('page:before-unload', $.proxy(@beforeUnload, this))
      $(document).one('page:load', $.proxy(@onChange, this))

    Turbolinks.visit(window.location.href)

  beforeUnload: ->
    @scrollPosition = $(document).scrollTop()

  onChange: ->
    $(document).scrollTop(@scrollPosition)

$ ->
  Turbolinks.reloadPage = (options = {}) ->
    new TurbolinksReloader().run(options)
