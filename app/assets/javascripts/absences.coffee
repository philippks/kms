jQuery ->
  $('#absence_from_date').on 'change', ->
    updateHours($('#absence_from_date').val(), $('#absence_to_date').val())

  $('#absence_to_date').on 'change', ->
    updateHours($('#absence_from_date').val(), $('#absence_to_date').val())

updateHours = (fromDate, toDate) ->
  $.ajax({
    url: "/absences/default_hours",
    data: {
      absence: {
        from_date: fromDate,
        to_date: toDate,
      }
    },
    success: (response) ->
      $('#absence_hours').val(response.default_hours)
    type: "GET"
  })
