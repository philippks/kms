jQuery ->
  # global options
  $.fn.select2.defaults.set('language', 'de')
  $.fn.select2.defaults.set('theme', 'bootstrap')
  $.fn.select2.defaults.set('allowClear', true)

  $('select.select2').each (index, select) ->
    $(select).select2({
      placeholder: $(select).attr('placeholder') || '',
      minimumResultsForSearch: 5,
    }).on('change', (element) ->
      if $(select).is('.filter_select')
        $('form').submit()
      )
