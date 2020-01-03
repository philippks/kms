class @CustomerSelect
  constructor: (selector, onChange) ->
    @onChangeCallback = onChange
    @initialize(selector)

  initialize: (selector) ->
    $(selector).select2(
      placeholder: $(selector).attr('placeholder') || '',
      ajax:
        dataType: 'json'
        url: '/customers.json',
        cache: true,
        delay: 250,
        data: (params) -> { query: params.term }
        processResults: @processResults
      current: @currentSelection
      minimumInputLength: 3
    ).on('change', @onChange)

  processResults: (data) ->
    results = []

    $.each(data, (index, item) ->
      results.push({
        'id': item.id,
        'text': item.display_name
      })
    )
    return {
      results: results
    }

  onChange: (element) =>
    @onChangeCallback($(element.target).val()) if @onChangeCallback

jQuery ->
  $('select.customer_select').each (index, select) ->
    new CustomerSelect(select)
