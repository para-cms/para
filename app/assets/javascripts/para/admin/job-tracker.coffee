class Para.JobTracker extends RemoteModalForm
  initialize: (options = {}) ->
    super(options)
    @refreshOnClose = false
    @trackProgress()

  formSuccess: (e, response) ->
    super(e, response)
    @trackProgress()

  trackProgress: ($progressBar) ->
    return unless ($progressBar = @$el.find('[data-async-progress]')).length

    @jobStatusURL = @$el.data('job-status-url')
    @progress = new Para.AsyncProgress(el: $progressBar, progressUrl: @jobStatusURL)
    @listenTo(@progress, 'completed', @onImportComplete)
    @listenTo(@progress, 'failed', @onImportComplete)

  onImportComplete: ->
    $.ajax(
      url: @jobStatusURL
      # Force HTTP ACCEPT header to HTML since Rails treats XHR request without
      # a specific ACCEPT header as JS or JSON by defaut.
      accepts:
        'html': 'text/html'
      dataType: 'html'
    ).done(@onFinalModalLoaded)

  onFinalModalLoaded: (response) =>
    @formSuccess(null, response)
    @refreshOnClose = true

  modalHide: ->
    super()
    @progress?.stop()

$(document).on 'page:change turbolinks:load', ->
  $('body').on 'ajax:success', '[data-job-tracker-button]', (e, response) ->
      new Para.JobTracker(modalMarkup: response, $link: $(e.currentTarget))
