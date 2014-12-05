
calendar = ->    
  date = new Date()
  d = date.getDate()
  m = date.getMonth()
  y = date.getFullYear()

  calendar = $("#calendar").fullCalendar(
    header:
      left: "prev,next today"
      center: "title"
      right: "month,agendaWeek,agendaDay"

    editable: true
    droppable: true
    selectable: true
    selectHelper: true
    
    select: (start, end, allDay) ->
      title = prompt("Event Title:")
      if title
        calendar.fullCalendar "renderEvent",
          title: title
          start: start
          end: end
          allDay: allDay
        , true
      calendar.fullCalendar "unselect"
      return

    drop: (date, allDay) ->
      originalEventObject = $(this).data("eventObject")
      copiedEventObject = $.extend({}, originalEventObject)
      copiedEventObject.start = date
      copiedEventObject.allDay = allDay
      $("#calendar").fullCalendar "renderEvent", copiedEventObject, true
      $(this).remove()  if $("#drop-remove").is(":checked")
      return
  )
 

$(document).on 'page:change', ->
  if $("#calendar").length > 0
    calendar()
    
