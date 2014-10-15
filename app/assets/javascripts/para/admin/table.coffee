class Para.ResourceTable
  constructor: (@$table) ->
    @$tbody = @$table.find('tbody')
    @initializeOrderable()

  initializeOrderable: ->
    @orderable = @$table.hasClass('orderable')

    return unless @orderable

    @orderUrl = @$table.data('order-url')

    @$tbody.sortable
      handle: '.order-anchor'
      forcePlaceholderSize: true

    @$tbody.on('sortupdate', $.proxy(@sortUpdate, this))

  sortUpdate: ->
    @$tbody.find('tr').each (i, el) ->
      $(el).find('.resource-position-field').val(i)

    @updateOrder()

  updateOrder: ->
    Para.ajax(
      url: @orderUrl
      method: 'patch'
      data:
        resources: @buildOrderedData()
      success: $.proxy(@orderUpdated, this)
    )

  buildOrderedData: ->
    for i, field of @$tbody.find('.resource-position-field').get()
      $field = $(field)
      { id: $field.closest('.order-anchor').data('id'), position: $field.val() }

  orderUpdated: ->
    # TODO: Add flash message to display ordering success

$(document).on 'page:change', ->
  $('.para-component-relation-table').each (i, el) ->
    new Para.ResourceTable($(el))
