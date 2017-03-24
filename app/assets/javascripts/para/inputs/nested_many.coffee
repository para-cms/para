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

  afterInsertField: (e, $element) ->
    if ($collapsible = $element.find('[data-open-on-insert="true"]')).length
      @openInsertedField($collapsible)

    if @orderable
      @$fieldsList.sortable('destroy')
      @initializeOrderable()
      @sortUpdate()

    $element.simpleForm()

  openInsertedField: ($field) ->
    $target = $($field.attr('href'))
    $target.collapse('show')

  collapseShown: (e) ->
    $target = $(e.target)
    $field = @$field.find("[data-toggle='collapse'][href='##{ $target.attr('id') }']")
    scrollOffset = -($('[data-header]').outerHeight() + 20)
    $.scrollTo($field, 200, offset: scrollOffset)
    $target.find('input, textarea, select').eq('0').focus()


$.simpleForm.onDomReady ->
  $('.nested-many-field').each (i, el) -> new Para.NestedManyField($(el))
