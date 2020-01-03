jQuery ->
  $('#hours_calendar').fullCalendar
    defaultDate: $('#hours_calendar').data('month'),
    firstDay: 1,
    weekends: true,
    editable: false,
    header:
      left: '',
      center: 'title',
      right: ''
    defaultView: 'month',
    height: 500,

    eventSources: [{
      url: '/hours/calendar_events.json',
      data: ->
        date = $('#hours_calendar').fullCalendar('getDate')._d
        firstDay = new Date(date.getFullYear(), date.getMonth(), 1)
        lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0)

        firstDay = moment(firstDay).format('YYYY-MM-DD')
        lastDay = moment(lastDay).format('YYYY-MM-DD')

        return {
          from: firstDay,
          to: lastDay,
        }
    }]

    eventClick: (calEvent, jsEvent, view) ->
      window.location = calEvent.url

$('#hours_calendar.fc-prev-button span').click(->
  alert('prev is clicked, do something')
)
