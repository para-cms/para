scrollToComponentSection = ($component, duration = 0) ->
  sectionOffset = $component.closest('.component-section-item').offset().top + $('.navmenu').scrollTop()
  headerHeight = $('.navmenu .navmenu-brand').outerHeight()
  $('.navmenu-nav').scrollTo(sectionOffset - headerHeight, duration: duration)

responsive_sidebar_navigation = ->
  # Scroll to active element's section on page change
  if ($activeItem = $('.component-item.active')).length
    scrollToComponentSection($activeItem)

  $('.component-item').on 'click', 'a', (e) ->
    scrollToComponentSection($(e.currentTarget), 150)

$(document).on 'page:change turbolinks:load', ->
  responsive_sidebar_navigation()

  $(".selectize-tags").selectize
    delimiter: ","
    persist: false
    create: (input) ->
      value: input
      text: input

$(window).resize ->
  responsive_sidebar_navigation()
