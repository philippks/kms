jQuery ->
  $('.invoices-wizard').each (index) ->
    $('.editable').editable({
      mode: 'inline'
      unsavedclass: null
      emptytext: ->
        if $(this).data('data-success')
          return '...'
      success: ->
        $(this).data('data-success', true)
        location.reload()
      error: ->
    })
