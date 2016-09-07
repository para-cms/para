class Para.AsyncProgress extends Vertebra.View
  initialize: (options) ->
    @targetUrl = options.progressUrl || @$el.data('async-progress-url')
    @$progressBar = @$el.find('.progress-bar')
    @trackProgress()

  trackProgress: =>
    $.get(@targetUrl).done(@onTrackingDataReceived).fail(@onJobError)

  stop: ->
    clearTimeout(@progressTimeout)

  onTrackingDataReceived: (data) =>
    if data.status is 'completed' then @completed() else @setProgress(data.progress)

  setProgress: (progress) ->
    @$progressBar.css(width: "#{ progress }%")
    @progressTimeout = setTimeout(@trackProgress, 1500)
    @trigger('progress')

  completed: ->
    @$progressBar.css(width: "100%")
    @$progressBar.removeClass('progress-bar-striped').addClass('progress-bar-success')
    @trigger('completed')

  onJobError: =>
    @$progressBar.css(width: "100%")
    @$progressBar.removeClass('progress-bar-striped').addClass('progress-bar-error')
    @trigger('failed')
