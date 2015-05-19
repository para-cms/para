# collapse_sidebar = (event) ->
#   event.stopPropagation()
#   li = $(this)
#   if li.hasClass('active')
#     li.removeClass 'active'
#     li.find('li.active').removeClass 'active'
#   else
#     li.parent().find('.xn-openable').removeClass 'active'
#     li.addClass 'active'

scrollToComponentSection = ($component, duration = 0) ->
  sectionOffset = $component.closest('.component-section-item').offset().top + $('.page-sidebar').scrollTop()
  headerHeight = $('.page-sidebar .brand-logo').outerHeight()
  $('.page-sidebar').scrollTo(sectionOffset - headerHeight, duration: duration)

responsive_sidebar_navigation = ->
  # document_width = $(document).width()
  # if document_width < 1024
  #   $('.page-sidebar .xn-openable')
  #     .each ->
  #       li = $(this)
  #       li.removeClass 'active'

  #     .on 'click', collapse_sidebar

  # else
  #   $('.page-sidebar .xn-openable')
  #     .each ->
  #       li = $(this)
  #       li.addClass 'active'

  #     .off 'click', collapse_sidebar

  # Scroll to active element's section on page change
  if ($activeItem = $('.component-item.active')).length
    scrollToComponentSection($activeItem)

  $('.component-item').on 'click', 'a', (e) ->
    console.log 'scroll to ', $(e.currentTarget).closest('.component-item')
    scrollToComponentSection($(e.currentTarget), 150)



# init_navigation_horizontal = ->
#   $('.x-navigation-horizontal  li > a').click ->
#     li = $(this).parent('li')
#     ul = li.parent('ul')
#     ul.find(' > li').not(li).removeClass 'active'
#     return

#   $('.x-navigation-horizontal li').click (event) ->
#     event.stopPropagation()
#     li = $(this)
#     if li.children('ul').length > 0 or li.children('.panel').length > 0
#       if li.hasClass('active')
#         li.removeClass 'active'
#         li.find('li.active').removeClass 'active'
#       else
#         li.addClass 'active'


$(document).on 'page:change', ->
  # init_navigation_horizontal()
  responsive_sidebar_navigation()

  $(".selectize-tags").selectize
    delimiter: ","
    persist: false
    create: (input) ->
      value: input
      text: input

  # $(".x-navigation-control").click ->
  #   $(this).parents(".x-navigation").toggleClass "x-navigation-open"
  #   false

$(window).resize ->
  responsive_sidebar_navigation()
