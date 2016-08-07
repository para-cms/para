class Para.ResourceTree
  constructor: (@$el) ->
    @initializeTree()

  initializeTree: ->
    @orderUrl = @$el.data('url')
    @maxDepth = parseInt @$el.data('max-depth')

    $(".tree")
      .sortable
        handle: ".handle"
        items: ".node"
        connectWith: ".tree"
      .on('sortupdate', $.proxy(@sortUpdate, this))

  sortUpdate: (e, data) ->
    @handlePlaceholder($el) for $el in [data.endparent, data.startparent, data.item.find('.tree')]
    @updateOrder()

  handlePlaceholder: ($el) ->
    $placeholder = $el.find("> .placeholder")
    if $el.parents('.tree').length - 1 >= @maxDepth or $el.find('> .node').length
      $placeholder.hide()
      $el.children("> .tree").each (index, el) => @handlePlaceholder $(el)
    else
      $placeholder.show()

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
    $(".node").each (index) ->
      $this = $(this)
      data[index] = {
        id: $this.data("id"),
        position: index,
        parent_id: $this.parent().parent().data("id")
      }
    data

  orderUpdated: ->
    # TODO: Add flash message to display ordering success

$(document).on 'page:change turbolinks:load', ->
  $('.root-tree').each (i, el) ->
    new Para.ResourceTree($(el))
