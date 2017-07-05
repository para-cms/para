# Allows to handle a form in a modal with rails' jquery-ujs remote links and
# forms feature, without having to write any extra javascript
#
class @RemoteModalForm extends Vertebra.View
  events:
    'ajax:success form[data-remote]': 'formSuccess'
    'ajax:success a[data-remote]': 'pageLoaded'
    'ajax:error [data-remote]': 'formError'
    'ajax:aborted:file [data-remote]': 'handleFormWithFiles'
    'hidden.bs.modal': 'modalHidden'
    'hide.bs.modal': 'modalHide'

  initialize: (options = {}) ->
    { modalMarkup, @$link, refreshOnClose } = options
    @replaceModalWith(modalMarkup)
    @refreshOnClose = if refreshOnClose? then refreshOnClose else @$link?.data('refresh-on-close')
    @trigger('shown')

  formSuccess: (e, response) ->
    @formDidSuccess = true
    @handleModalResponse(response)
    @trigger('success')

  formError: (e, jqXHR) ->
    @replaceModalWith(jqXHR.responseText)
    @trigger('error')

  # Intercept form jquery-ujs form submission when there are non-blank file
  # inputs in the `remote` form, so we can submit the form through
  # jquery.iframe-transport
  #
  handleFormWithFiles: (e) ->
    @submitWithIframe($(e.currentTarget))
    return false

  submitWithIframe: ($form) ->
    jqXHR = jQuery.ajax
      url: $form.attr('action')
      method: $form.attr('method')
      files: $form.find(':file')
      iframe: true
      data: $form.find('input:not(:file), textarea, select').serializeArray()
      processData: false

    jqXHR
      .done (data) => @formSuccess(null, data)
      .fail (jqXHR) => @formError(null, jqXHR)

  pageLoaded: (e, response) ->
    @handleModalResponse(response)

  handleModalResponse: (response) ->
    if response and $.trim(response).length
      @replaceModalWith(response)
    else
      @hideModal()

  replaceModalWith: (modalMarkup) ->
    @hideModal()
    @setElement($(modalMarkup).appendTo('body').modal())
    @$el.data('remote-modal-form', this)
    @showModal()

  showModal: ->
    @$el.simpleForm?()

  hideModal: (options = {}) ->
    @$el?.modal('hide')

  modalHide: (e) ->
    @refreshPage()

  modalHidden: (e) ->
    $(e.currentTarget).remove()
    @trigger('hide')
    @trigger('close') if @$el[0] is $(e.currentTarget)[0]

  refreshPage: ->
    Turbolinks.reloadPage() if @refreshOnClose and @formDidSuccess

  trigger: (event, args...) ->
    super(event, args...)
    @$el.trigger("remote-modal-form:#{ event }", args)

# Lazy initialization when the link target is loaded
#
$(document).on 'page:change turbolinks:load', ->
  $('body').on 'ajax:success', '[data-remote-modal-form]', (e, response) ->
    new RemoteModalForm(modalMarkup: response, $link: $(e.currentTarget))
