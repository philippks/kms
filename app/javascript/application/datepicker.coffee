jQuery ->
  $('.input-group.date').each (index, select) ->
    $(select).datepicker({
        format: "dd.mm.yyyy",
        todayBtn: "linked",
        language: "de",
        autoclose: true,
        todayHighlight: true,
        clearBtn: $('.input-group.date').find('input').data('clearbtn') != false,
        keyboardNavigation: false
      }).on('show', (event) ->
        @date_on_show = event.date
      ).on('hide', (event) ->
          if $(select).has('.filter_date_picker').length
            unless moment(event.date).isSame(@date_on_show)
              $(select).closest('form').submit()
      )
