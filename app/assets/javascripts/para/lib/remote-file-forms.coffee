# This class handles rails' remote form 'ajax:aborted:file' event to serialize
# forms with files and send them through ajax using the `FormData` HTML5
# feature.
#
# The general approach and request implementation respects the same lifecycle
# of original rails' remote form requests, to allow existing handling code
# to run without any modification.
#
class RemoteFileForm
  constructor: (options = {}) ->
    @$el = $(options.el)
    @submitForm() if $.rails.fire(@$el, 'ajax:before')

  submitForm: ->
    formData = new FormData(@$el[0])
    url = @$el.attr('action')
    method = @$el.attr('method')

    Para.ajax
      url: url
      method: method
      data: formData
      cache: false
      contentType: false
      processData: false
      xhr: @buildXHR
      beforeSend: @beforeSend
      success: @success
      complete: @complete
      error: @error
      crossDomain: $.rails.isCrossDomain(url)

  buildXHR: =>
    xhr = $.ajaxSettings.xhr()
    $(xhr.upload).on('progress', @progress) if xhr.upload
    xhr

  beforeSend: (xhr, settings) =>
    if $.rails.fire(@$el, 'ajax:beforeSend', [xhr, settings])
      @$el.trigger('ajax:send', xhr)
    else
      return false

  success: (data, status, xhr) =>
    @$el.trigger('ajax:success', [data, status, xhr])

  complete: (xhr, status) =>
    @$el.trigger('ajax:complete', [xhr, status])

  error: (xhr, status, error) =>
    @$el.trigger('ajax:error', [xhr, status, error])

  # TODO : Implement an upload progress bar for heavy files
  #
  progress: (e) =>
    # console.log e.loaded, '/', e.total if e.lengthComputable

$(document).on 'ajax:aborted:file', (e) ->
  new RemoteFileForm(el: e.target)
  return false
