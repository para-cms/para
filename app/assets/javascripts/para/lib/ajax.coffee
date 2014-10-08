Para.ajax = (options = {}) ->
  csrfParam = $('meta[name="csrf-param"]').attr('content')
  csrfToken = $('meta[name="csrf-token"]').attr('content')

  csrfOptions = {}
  csrfOptions[csrfParam] = csrfToken if csrfParam and csrfToken

  unless options.method and options.method.match(/get/i)
    options = $.extend(csrfOptions, options)

  $.ajax(options)
