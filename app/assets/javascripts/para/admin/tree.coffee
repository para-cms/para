class Para.ResourceTree
  constructor: (@$el) ->
    @initializeTree()

  initializeTree: ->
    @orderUrl = @$el.data('url')

    $(".tree")
      .sortable
        connectWith: ".tree"
      .on('sortupdate', $.proxy(@sortUpdate, this))

  sortUpdate: ->
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
    data = {}
    $(".tree-item").each (index) ->
      $this = $(this)
      data[index] = { 
        id: $this.data("id"), 
        position: index, 
        parent_id: $this.parent().parent().data("id") 
      }
    data

  orderUpdated: ->
    # TODO: Add flash message to display ordering success

$(document).on 'page:change', ->
  $('.sortable-tree').each (i, el) ->
    new Para.ResourceTree($(el))
