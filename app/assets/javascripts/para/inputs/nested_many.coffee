$(document).on 'page:change', ->
  $('form').on 'cocoon:before-remove', (e, $element) ->
    removeAlso = $element.find('[data-remove-also]').data('remove-also')
    $(removeAlso).hide() if removeAlso
