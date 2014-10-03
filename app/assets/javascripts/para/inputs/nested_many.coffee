$(document).on 'page:change', ->
  $('form').on 'cocoon:before-remove', (e, $element) ->
    removeAlso = $element.find('[data-remove-also]').data('remove-also')
    $(removeAlso).hide() if removeAlso

  $('form').on 'cocoon:after-insert', (e, $element) ->
    if ($collapsible = $element.find('[data-open-on-insert="true"]')).length
      $target = $($collapsible.attr('href'))
      $target.collapse('show')
      $.scrollTo($target, 200)
      $target.find('input, select').eq('0').focus()
