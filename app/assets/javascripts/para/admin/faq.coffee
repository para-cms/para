$(document).on 'page:change', ->

  $(".faq .faq-item .faq-title").click ->
    item = $(this).parent(".faq-item")
    if item.hasClass("active")
      $(this).find(".fa").removeClass("fa-angle-up").addClass "fa-angle-down"
    else
      $(this).find(".fa").removeClass("fa-angle-down").addClass "fa-angle-up"
    item.toggleClass "active"
    
    return

  $("#faqForm").on "submit", ->
    keyword = $("#faqSearchKeyword").val()
    if keyword.length >= 3
      $(".faq .faq-item").removeClass "active"
      $("#faqSearchResult").html ""
      $(".faq").removeHighlight()
      items = $(".faq .faq-text:contains('" + keyword + "')")
      items.highlight keyword
      items.each ->
        $(this).parent(".faq-item").addClass "active"
        return

      
      $("#faqSearchResult").html "<span class='text-success'>Found in " + items.length + " answers</span>"
    else
      $("#faqSearchResult").html "<span class='text-error'>Minimum 3 chars required</span>"
    false

  $("#faqOpenAll").click ->
    $(".faq .faq-item").addClass "active"
    
    return

  $("#faqCloseAll").click ->
    $(".faq .faq-item").removeClass "active"
    
    return

  $("#faqRemoveHighlights").click ->
    hl = $(".faq").find(".faq-highlight")
    hl.each ->
      txt = $(this).html()
      $(this).after txt
      $(this).remove()
