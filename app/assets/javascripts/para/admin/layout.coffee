

uiXnavPanel = ->
  $(".x-navigation  li > a").click ->
    li = $(this).parent("li")
    ul = li.parent("ul")
    ul.find(" > li").not(li).removeClass "active"


  $(".x-navigation li").click (event) ->
    event.stopPropagation()
    li = $(this)
    if li.children("ul").length > 0 or li.children(".panel").length > 0 or $(this).hasClass("xn-profile") > 0
      if li.hasClass("active")
        li.removeClass "active"
        li.find("li.active").removeClass "active"
      else
        li.addClass "active"
      if $(this).hasClass("xn-profile") > 0
        true
      else
        false

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
  # uiXnavPanel()  

  
