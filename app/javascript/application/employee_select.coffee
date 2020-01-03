class @EmployeeSelect
  constructor: (selector, onChange) ->
    @onChangeCallback = onChange

    @initialize(selector)

  initialize: (selector) ->
    $(selector).select2(
      placeholder: $(selector).attr('placeholder') || '',
      ajax:
        url: '/employees.json',
        dataType: 'json',
        cache: true
        delay: 250,
        data: (params) -> { query: params.term, deactivated: true }
        processResults: @processResults
      minimumInputLength: 3,
    ).on('change', @onChange)

  processResults: (data) ->
    results = []

    $.each(data, (index, item) ->
      results.push({
        'id': item.id,
        'text': item.name
      })
    )
    return {
      results: results
    }

  onChange: (element) =>
    @onChangeCallback(element.val) if @onChangeCallback

jQuery ->
  $('select.employee_select').each (index, select) ->
    new EmployeeSelect(select)
