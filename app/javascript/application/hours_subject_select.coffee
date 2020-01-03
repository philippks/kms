class @HoursSubjectSelect
  constructor: (selector, onChange) ->
    @initialize(selector)

  initialize: (selector) ->
    $(selector).select2(
      placeholder: $(selector).attr('placeholder') || '',
      ajax:
        url: '/hours/subjects.json',
        dataType: 'json',
        delay: 250,
        data: (params) -> { query: params.term }
        processResults: @processResults
        formatResult: @formatResult
        cache: true
      minimumInputLength: 0,
    ).on('select2:select', @onChange)

  processResults: (data) ->
    results = []

    $.each(data, (index, group) ->
      results.push({
        text: group.text,
        children: group.children.map( (item) ->
          {
            'id': item.id,
            'url': item.url,
            'text': item.name
          }
        )
      })
    )
    return {
      results: results
    }

  onChange: (element) =>
    window.location = element.params.data.url

jQuery ->
  $('select.hours_subject_select').each (index, select) ->
    new HoursSubjectSelect(select)
