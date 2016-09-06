class Para.Importer extends RemoteModalForm
  formSuccess: (e, response) ->
    super(e, response)

    if ($progressBar = @$el.find('[data-async-progress]')).length
      @trackProgress($progressBar)

  trackProgress: ($progressBar) ->
    @importStatusURL = @$el.data('import-status-url')
    progress = new Para.AsyncProgress(el: $progressBar, progressUrl: @importStatusURL)
    @listenTo(progress, 'completed', @onImportComplete)

  onImportComplete: ->
    $.ajax(
      url: @importStatusURL
      accepts:
        'html': 'text/html'
      dataType: 'html'
    ).done(@onFinalModalLoaded)

  onFinalModalLoaded: (response) =>
    @formSuccess(null, response)
    @refreshOnClose = true

$('body').on 'ajax:success', '[data-importer-button]', (e, response) ->
    new Para.Importer(modalMarkup: response, $link: $(e.currentTarget))
