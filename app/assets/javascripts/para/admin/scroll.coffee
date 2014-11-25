uiScroller = ->
  if $(".scroll").length > 0
    $(".scroll").mCustomScrollbar
      axis: "y"
      autoHideScrollbar: true
      scrollInertia: 20
      advanced:
        autoScrollOnFocus: false

$(document).on 'page:change', ->
  uiScroller()
