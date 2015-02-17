responsive_sidebar_navigation = ->
  document_width = $(document).width() 
  if document_width < 1024
    $('.page-sidebar .xn-openable')
      .each ->
        li = $(this)
        li.removeClass 'active'

      .click (event) ->
        event.stopPropagation()
        li = $(this)
        if li.hasClass('active')
          li.removeClass 'active'
          li.find('li.active').removeClass 'active'
        else
          li.addClass 'active'   

  else 
    $('.page-sidebar .xn-openable')
      .each ->
        li = $(this)
        li.addClass 'active'

      .click (event) ->
        event.stopPropagation()
        li = $(this)
        if li.hasClass('active')  
          return
        else
          li.addClass 'active'  

init_navigation_horizontal = ->
  $('.x-navigation-horizontal  li > a').click ->
    li = $(this).parent('li')
    ul = li.parent('ul')
    ul.find(' > li').not(li).removeClass 'active'
    return

  $('.x-navigation-horizontal li').click (event) ->
    event.stopPropagation()
    li = $(this)
    if li.children('ul').length > 0 or li.children('.panel').length > 0
      if li.hasClass('active')
        li.removeClass 'active'
        li.find('li.active').removeClass 'active'
      else
        li.addClass 'active'
    

page_content_size = ->  
  $content = $(".page-content")
  $sidebar = $(".page-sidebar")
  $navigation_top = $('.page-navigation-top-fixed .x-navigation-horizontal')
  
  navigation_top_height = $navigation_top.height() 

  document_height = $(document).height() - navigation_top_height if $content.height() < $(document).height()
  sidebar_height = $sidebar.height() - navigation_top_height if $sidebar.height() > $content.height()

  content_height = if sidebar_height > document_height then sidebar_height else document_height

  $content.height content_height


$(document).on 'page:change', ->
  page_content_size()
  init_navigation_horizontal()
  responsive_sidebar_navigation()

  $(".selectize-tags").selectize
    delimiter: ","
    persist: false
    create: (input) ->
      value: input
      text: input

  $(".x-navigation-control").click ->
    $(this).parents(".x-navigation").toggleClass "x-navigation-open"
    false

$(window).resize ->  
  page_content_size()
  responsive_sidebar_navigation()
