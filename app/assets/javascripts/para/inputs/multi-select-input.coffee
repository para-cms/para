class Para.MultiSelectInput extends Vertebra.View
  events:
    'keyup [data-search-field]': 'onSearchKeyUp'
    'click [data-add-all]': 'onAllItemsAdded'
    'click [data-remove-all]': 'onAllItemsRemoved'

  initialize: ->
    @$searchField = @$('[data-search-field]')
    @$selectedItems = @$('[data-selected-items] tbody')
    @$availableItems = @$('[data-available-items]')
    @$input = @$('[data-multi-select-input-field]')

    @searchURL = @$el.data('search-url')
    @orderable = @$el.is('[data-orderable]')

    @noSelectedItemsTemplate = @$('[data-no-selected-items]').data('no-selected-items')
    @noAvailableItemsTemplate = @$('[data-no-available-items]').data('no-available-items')

    @availableItems = []
    @selectedItems = (@buildSelectedItem(el) for el in @$selectedItems.find('[data-selected-item-id]'))
    @refreshSelectedItems()
    @refreshAvailableItems()

  onSearchKeyUp: ->
    @searchFor(@$searchField.val())

  searchFor: (terms) ->
    return if terms is @terms
    @terms = terms
    $.get(@searchURL, search: terms).done(@onSearchReturn)

  onSearchReturn: (results) =>
    @$('[data-available-items] tbody').html(results)
    @refreshAvailableItems()

  refreshAvailableItems: ->
    item.destroy() for item in @availableItems
    @availableItems = (@buildAvailableItem(el) for el in @$('[data-available-items] tr'))
    @showEmptyListHint(@noAvailableItemsTemplate, @$availableItems) unless @availableItems.length

  buildAvailableItem: (el) ->
    availableItem = new Para.MultiSelectAvailableItem(el: el)
    availableItem.setSelected(true) for selectedItem in @selectedItems when selectedItem.id is availableItem.id
    @listenTo(availableItem, 'add', @onItemAdded)
    availableItem

  onItemAdded: (item) =>
    @selectItem(item)

  buildSelectedItem: (el) ->
    selectedItem = new Para.MultiSelectSelectedItem(el: el)
    @listenTo(selectedItem, 'remove', @onItemRemoved)
    selectedItem

  selectItem: (item) ->
    return if @alreadySelected(item)

    item.setSelected(true)
    selectedItem = @buildSelectedItem(item.$el.attr('data-selected-item-template'))
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

    if @selectedItems.length
      @initializeOrderable()
    else
      @showEmptyListHint(@noSelectedItemsTemplate, @$selectedItems)

  showEmptyListHint: (template, $container) ->
    $(template).appendTo($container)

  onItemRemoved: (selectedItem) =>
    itemIndex = index for item, index in @selectedItems when item.id is selectedItem.id
    @selectedItems.splice(itemIndex, 1)
    selectedItem.destroy()
    @refreshSelectedItems()

    availableItem = item for item in @availableItems when item.id is selectedItem.id
    availableItem.setSelected(false) if availableItem

  onAllItemsAdded: ->
    return unless @availableItems.length

    @selectItem(availableItem) for availableItem in @availableItems

  onAllItemsRemoved: ->
    return unless @selectedItems.length

    @selectedItems = []
    @refreshSelectedItems()

    item.setSelected(false) for item in @availableItems

  initializeOrderable: ->
    return unless @orderable

    columnsCount = @$selectedItems.find('> tr > td').length

    @$selectedItems.sortable('destroy')

    @$selectedItems.sortable
      handle: '.order-anchor'
      forcePlaceholderSize: true
      placeholder: "<tr><td colspan='#{ columnsCount }'></td></tr>"

    @$selectedItems.on('sortupdate', @selectedItemsSorted)

  selectedItemsSorted: =>
    indices = {}
    indices[$(el).data('selected-item-id')] = index for el, index in @$selectedItems.find('[data-selected-item-id]')

    @selectedItems.sort (a, b) =>
      aIndex = indices[a.id]
      bIndex = indices[b.id]
      if aIndex > bIndex then 1 else -1

    @refreshSelectedItems()


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

  removeItem: (e) =>
    @trigger('remove', this)


$.simpleForm.onDomReady ($document) ->
  $document.find('[data-multi-select-input]').each (i, el) -> new Para.MultiSelectInput(el: el)
