jQuery ->
  $('#target_hours_calendar').fullCalendar
    weekends: false,
    editable: false,
    header:
      left: 'prev,next today',
      center: 'title',
      right: ''
    defaultView: 'month',
    defaultDate: $('#target_hours_calendar').attr('defaultDate'),
    height: 500,

    eventSources: [{
      url: '/target_hours.json',
    }],

    dayClick: (date, jsEvent, view) ->
      updateEvent(date)

    eventClick: (event, jsEvent, view) ->
      updateEvent(event.start)

updateEvent = (date) ->
  $.ajax({
    url: "/target_hours/",
    data: {
      date: date.format('YYYYMMDD')
    },
    type: "PATCH"
  })
  .done(
    $('#target_hours_calendar').fullCalendar('refetchEvents')
  )
