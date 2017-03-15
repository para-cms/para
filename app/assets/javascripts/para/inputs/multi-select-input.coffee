class Para.MultiSelectInput extends Vertebra.View
  events:
    'keyup [data-search-field]': 'onSearchKeyUp'

  initialize: ->
    @$searchField = @$('[data-search-field]')
    @$selectedItems = @$('[data-selected-items]')
    @$input = @$('[data-multi-select-input-field]')

    @searchURL = @$el.data('search-url')

    @availableItems = []
    @selectedItems = (@buildSelectedItem(el) for el in @$selectedItems.find('[data-selected-item-id]'))
    @refreshSelectedItems()

  onSearchKeyUp: ->
    @searchFor(@$searchField.val())

  searchFor: (terms) ->
    return if terms is @terms
    @terms = terms
    $.get(@searchURL, search: terms).done(@onSearchReturn)

  onSearchReturn: (results) =>
    @$('[data-available-items]').html(results)

    item.destroy() for item in @availableItems
    @availableItems = (@buildAvailableItem(el) for el in @$('[data-available-items] tr'))

  buildAvailableItem: (el) ->
    availableItem = new Para.MultiSelectAvailableItem(el: el)
    availableItem.setSelected(true) for selectedItem in @selectedItems when selectedItem.id is availableItem.id
    @listenTo(availableItem, 'add', @onItemAdded)
    availableItem

  onItemAdded: (item) =>
    @selectItem(item)
    item.setSelected(true)

  buildSelectedItem: (el) ->
    selectedItem = new Para.MultiSelectSelectedItem(el: el)
    @listenTo(selectedItem, 'remove', @onItemRemoved)
    selectedItem

  selectItem: (item) ->
    return if @alreadySelected(item)
    selectedItem = @buildSelectedItem(item.$el.next().clone()[0])
    @selectedItems.push(selectedItem)
    @refreshSelectedItems()

  alreadySelected: (item) ->
    return true for selectedItem in @selectedItems when selectedItem.id is item.id
    false

  refreshSelectedItems: ->
    @$selectedItems.empty()
    selectedItem.renderTo(@$selectedItems) for selectedItem in @selectedItems

    selectedItemIds = (selectedItem.id for selectedItem in @selectedItems).join(', ')
    @$input.val(selectedItemIds)

  onItemRemoved: (selectedItem) =>
    itemIndex = index for item, index in @selectedItems when item.id is selectedItem.id
    @selectedItems.splice(itemIndex, 1)
    selectedItem.destroy()
    @refreshSelectedItems()

    availableItem = item for item in @availableItems when item.id is selectedItem.id
    availableItem.setSelected(false) if availableItem


class Para.MultiSelectAvailableItem extends Vertebra.View
  events:
    'click [data-add-item]': 'addItem'

  initialize: ->
    @id = @$el.data('available-item-id')

  addItem: ->
    @trigger('add', this)

  setSelected: (@selected) ->
    @$el.toggleClass('selected', @selected)


class Para.MultiSelectSelectedItem extends Vertebra.View
  initialize: ->
    @id = @$el.data('selected-item-id')

  bindEvents: ->
    @$('[data-remove-item]').on 'click', @removeItem

  renderTo: ($container) ->
    @$el.appendTo($container)
    @bindEvents()
    # @delegateEvents()

  removeItem: (e) =>
    @trigger('remove', this)


$(document).on 'page:change turbolinks:load', ->
  $('[data-multi-select-input]').each (i, el) -> new Para.MultiSelectInput(el: el)
