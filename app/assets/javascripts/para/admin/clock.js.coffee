
tp_clock_time = ->
  now = new Date()
  hour = now.getHours()
  minutes = now.getMinutes()
  hour = (if hour < 10 then "0" + hour else hour)
  minutes = (if minutes < 10 then "0" + minutes else minutes)
  $(".plugin-clock").html hour + "<span>:</span>" + minutes
  return
  

tp_date = ->
  if $(".plugin-date").length > 0
    days = [
      "Dimanche"
      "Lundi"
      "Mardi"
      "Mercredi"
      "Jeudi"
      "Vendredi"
      "Samedi"
    ]
    months = [
      "Janvier"
      "Février"
      "Mars"
      "Avril"
      "Mai"
      "Juin"
      "Juillet"
      "Août"
      "Septebmre"
      "Octobre"
      "Novembre"
      "Decembre"
    ]
    now = new Date()
    day = days[now.getDay()]
    date = now.getDate()
    month = months[now.getMonth()]
    year = now.getFullYear()
    $(".plugin-date").html day + ", " + month + " " + date + ", " + year
  return

$(document).on 'page:change', ->
  if $(".plugin-clock").length > 0
    tp_clock_time()
    window.setInterval (->
      tp_clock_time()
      return
    ), 10000

  if $(".plugin-date").length > 0  
    tp_date()
