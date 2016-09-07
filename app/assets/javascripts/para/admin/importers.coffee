class Para.Importer extends RemoteModalForm
  initialize: (options = {}) ->
    super(options)
    @refreshOnClose = false

  formSuccess: (e, response) ->
    super(e, response)

    if ($progressBar = @$el.find('[data-async-progress]')).length
      @trackProgress($progressBar)

  trackProgress: ($progressBar) ->
    @importStatusURL = @$el.data('import-status-url')
    @progress = new Para.AsyncProgress(el: $progressBar, progressUrl: @importStatusURL)
    @listenTo(@progress, 'completed', @onImportComplete)
    @listenTo(@progress, 'failed', @onImportComplete)

  onImportComplete: ->
    $.ajax(
      url: @importStatusURL
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
  $('body').on 'ajax:success', '[data-importer-button]', (e, response) ->
      new Para.Importer(modalMarkup: response, $link: $(e.currentTarget))
