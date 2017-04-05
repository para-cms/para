class Para.NestedManyField
  constructor: (@$field) ->
    @$fieldsList = @$field.find('.fields-list')

    @initializeOrderable()
    @initializeCocoon()

    @$field.on 'shown.bs.collapse', $.proxy(@collapseShown, this)

  initializeOrderable: ->
    @orderable = @$field.hasClass('orderable')
    return unless @orderable

    @$fieldsList.sortable
      handle: '.order-anchor'
      forcePlaceholderSize: true

    @$fieldsList.on('sortupdate', $.proxy(@sortUpdate, this))

  sortUpdate: ->
    @$fieldsList.find('.form-fields').each (i, el) ->
      $(el).find('.resource-position-field').val(i)

  initializeCocoon: ->
    @$fieldsList.on 'cocoon:after-insert', $.proxy(@afterInsertField, this)
    @$fieldsList.on 'cocoon:before-remove', $.proxy(@beforeRemoveField, this)

  afterInsertField: (e, $element) ->
    if ($collapsible = $element.find('[data-open-on-insert="true"]')).length
      @openInsertedField($collapsible)

    if @orderable
      @$fieldsList.sortable('destroy')
      @initializeOrderable()
      @sortUpdate()

    $element.simpleForm()

  beforeRemoveField: (e, $element) ->
    $nextEl = $element.next()
    # Remove attributes mappings field for new records since it will try to
    # create an empty nested resource otherwise
    $nextEl.remove() if $nextEl.is('[data-attributes-mappings]') and not $element.is('[data-persisted]')

  openInsertedField: ($field) ->
    $target = $($field.attr('href'))
    $target.collapse('show')

  collapseShown: (e) ->
    $target = $(e.target)
    $field = @$field.find("[data-toggle='collapse'][href='##{ $target.attr('id') }']")
    scrollOffset = -($('[data-header]').outerHeight() + 20)
    $.scrollTo($field, 200, offset: scrollOffset)
    $target.find('input, textarea, select').eq('0').focus()


$.simpleForm.onDomReady ($document) ->
  $document.find('.nested-many-field').each (i, el) -> new Para.NestedManyField($(el))
