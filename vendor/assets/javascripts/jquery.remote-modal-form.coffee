# Allows to handle a form in a modal with rails' jquery-ujs remote links and
# forms feature, without having to write any extra javascript
#
class @RemoteModalForm extends Vertebra.View
  events:
    'ajax:success form[data-remote]': 'formSuccess'
    'ajax:success a[data-remote]': 'pageLoaded'
    'ajax:error [data-remote]': 'formError'
    'hidden.bs.modal': 'modalHidden'
    'hide.bs.modal': 'refreshPage'

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
