onload = ->
  x_navigation_onresize()
  page_content_onresize()
  return

page_content_onresize = ->
  $(".page-content,.content-frame-body,.content-frame-right,.content-frame-left").css("width", "").css "height", ""
  content_minus = 0
  content_minus = (if ($(".page-container-boxed").length > 0) then 40 else content_minus)
  content_minus += (if ($(".page-navigation-top-fixed").length > 0) then 50 else 0)
  content = $(".page-content")
  sidebar = $(".page-sidebar")
  content.height $(document).height() - content_minus  if content.height() < $(document).height() - content_minus
  content.height sidebar.height()  if sidebar.height() > content.height()

  if $(window).width() > 1024
    if $(".page-sidebar").hasClass("scroll")
      if $("body").hasClass("page-container-boxed")
        doc_height = $(document).height() - 40
      else
        doc_height = $(window).height()
      $(".page-sidebar").height doc_height
    if $(".content-frame-body").height() < $(document).height() - 162
      $(".content-frame-body,.content-frame-right,.content-frame-left").height $(document).height() - 162
    else
      $(".content-frame-right,.content-frame-left").height $(".content-frame-body").height()
    $(".content-frame-left").show()
    $(".content-frame-right").show()
  else
    $(".content-frame-body").height $(".content-frame").height() - 80
    $(".page-sidebar").css "height", ""  if $(".page-sidebar").hasClass("scroll")
  if $(window).width() < 1200
    $("body").removeClass("page-container-boxed").data "boxed", "1"  if $("body").hasClass("page-container-boxed")
  else
    $("body").addClass("page-container-boxed").data "boxed", ""  if $("body").data("boxed") is "1"
  return

# PANEL FUNCTIONS
panel_collapse = (panel, action, callback) ->
  if panel.hasClass("panel-toggled")
    panel.removeClass "panel-toggled"
    panel.find(".panel-collapse .fa-angle-up").removeClass("fa-angle-up").addClass "fa-angle-down"
    callback()  if action and action is "shown" and typeof callback is "function"
    onload()
  else
    panel.addClass "panel-toggled"
    panel.find(".panel-collapse .fa-angle-down").removeClass("fa-angle-down").addClass "fa-angle-up"
    callback()  if action and action is "hidden" and typeof callback is "function"
    onload()
  return

panel_refresh = (panel, action, callback) ->
  unless panel.hasClass("panel-refreshing")
    panel.append "<div class=\"panel-refresh-layer\"><img src=\"img/loaders/default.gif\"/></div>"
    panel.find(".panel-refresh-layer").width(panel.width()).height panel.height()
    panel.addClass "panel-refreshing"
    callback()  if action and action is "shown" and typeof callback is "function"
  else
    panel.find(".panel-refresh-layer").remove()
    panel.removeClass "panel-refreshing"
    callback()  if action and action is "hidden" and typeof callback is "function"
  onload()
  return

panel_remove = (panel, action, callback) ->
  callback()  if action and action is "before" and typeof callback is "function"
  panel.animate
    opacity: 0
  , 200, ->
    $(this).remove()
    callback()  if action and action is "after" and typeof callback is "function"
    onload()
    return

  return

# EOF PANEL FUNCTIONS

# X-NAVIGATION CONTROL FUNCTIONS
x_navigation_onresize = ->
  inner_port = window.innerWidth or $(document).width()
  if inner_port < 1025
    $(".page-sidebar .x-navigation").removeClass "x-navigation-minimized"
    $(".page-container").removeClass "page-container-wide"
    $(".page-sidebar .x-navigation li.active").removeClass "active"
    $(".x-navigation-horizontal").each ->
      $(".x-navigation-horizontal").addClass("x-navigation-h-holder").removeClass "x-navigation-horizontal"  unless $(this).hasClass("x-navigation-panel")
      return

  else
    x_navigation_minimize "close"  if $(".page-navigation-toggled").length > 0
    $(".x-navigation-h-holder").addClass("x-navigation-horizontal").removeClass "x-navigation-h-holder"
  return

x_navigation_minimize = (action) ->
  if action is "open"
    $(".page-container").removeClass "page-container-wide"
    $(".page-sidebar .x-navigation").removeClass "x-navigation-minimized"
    $(".x-navigation-minimize").find(".fa").removeClass("fa-indent").addClass "fa-dedent"
    $(".page-sidebar.scroll").mCustomScrollbar "update"
  if action is "close"
    $(".page-container").addClass "page-container-wide"
    $(".page-sidebar .x-navigation").addClass "x-navigation-minimized"
    $(".x-navigation-minimize").find(".fa").removeClass("fa-dedent").addClass "fa-indent"
    $(".page-sidebar.scroll").mCustomScrollbar "disable", true
  $(".x-navigation li.active").removeClass "active"
  return

x_navigation = ->
  $(".x-navigation-control").click ->
    $(this).parents(".x-navigation").toggleClass "x-navigation-open"
    onresize()
    false

  x_navigation_minimize "close"  if $(".page-navigation-toggled").length > 0
  $(".x-navigation-minimize").click ->
    if $(".page-sidebar .x-navigation").hasClass("x-navigation-minimized")
      $(".page-container").removeClass "page-navigation-toggled"
      x_navigation_minimize "open"
    else
      $(".page-container").addClass "page-navigation-toggled"
      x_navigation_minimize "close"
    onresize()
    false

  $(".x-navigation  li > a").click ->
    li = $(this).parent("li")
    ul = li.parent("ul")
    ul.find(" > li").not(li).removeClass "active"
    return

  $(".x-navigation li").click (event) ->
    li = $(event.target).closest('li')

    if li.children("ul").length > 0 or li.children(".panel").length > 0 or li.hasClass("xn-profile") > 0
      event.stopPropagation()

      if li.hasClass("active")
        li.removeClass "active"
        li.find("li.active").removeClass "active"
      else
        li.addClass "active"
      onresize()
      if li.hasClass("xn-profile") > 0
        true
      else
        false


  # XN-SEARCH
  $(".xn-search").on "click", ->
    $(this).find("input").focus()
    return

  return

# END XN-SEARCH

# EOF X-NAVIGATION CONTROL FUNCTIONS

# PAGE ON RESIZE WITH TIMEOUT
onresize = (timeout) ->
  timeout = (if timeout then timeout else 200)
  setTimeout (->
    page_content_onresize()
    return
  ), timeout
  return

# EOF PAGE ON RESIZE WITH TIMEOUT
$(document).on 'page:change', ->

  onload()
  x_navigation()

  html_click_avail = true
  $("html").on "click", ->
    $(".x-navigation-horizontal li,.x-navigation-minimized li").removeClass "active"  if html_click_avail
    return

  $(".widget-remove").on "click", ->
    $(this).parents(".widget").fadeOut 400, ->
      $(this).remove()
      $("body > .tooltip").remove()
    false

  $(".dropdown-toggle").on "click", ->
    onresize()

  $(".panel-collapse").on "click", ->
    panel_collapse $(this).parents(".panel")
    $(this).parents(".dropdown").removeClass "open"
    false

  $(".panel-remove").on "click", ->
    panel_remove $(this).parents(".panel")
    $(this).parents(".dropdown").removeClass "open"
    false

  $(".panel-refresh").on "click", ->
    panel = $(this).parents(".panel")
    panel_refresh panel
    setTimeout (->
      panel_refresh panel
      return
    ), 3000
    $(this).parents(".dropdown").removeClass "open"
    false

  $(".accordion .panel-title a").on "click", ->
    blockOpen = $(this).attr("href")
    accordion = $(this).parents(".accordion")
    noCollapse = accordion.hasClass("accordion-dc")
    if $(blockOpen).length > 0
      if $(blockOpen).hasClass("panel-body-open")
        $(blockOpen).slideUp 200, ->
          $(this).removeClass "panel-body-open"
          return

      else
        $(blockOpen).slideDown 200, ->
          $(this).addClass "panel-body-open"
          return

      unless noCollapse
        accordion.find(".panel-body-open").not(blockOpen).slideUp 200, ->
          $(this).removeClass "panel-body-open"
          return

      false

  $(".toggle").on "click", ->
    elm = $("#" + $(this).data("toggle"))
    if elm.is(":visible")
      elm.addClass("hidden").removeClass "show"
    else
      elm.addClass("show").removeClass "hidden"
    false


$(window).resize ->
  x_navigation_onresize()
  page_content_onresize()

# NEW OBJECT(GET SIZE OF ARRAY)
Object.size = (obj) ->
  size = 0
  key = undefined
  for key of obj
    size++  if obj.hasOwnProperty(key)
  size

# EOF NEW OBJECT(GET SIZE OF ARRAY)
