class ActivityTextInput
  constructor: (selector, onChange) ->
    @onChangeCallback = onChange
    @initialize(selector)

  initialize: (selector) ->
    $(selector).easyAutocomplete(@options())

  options: ->
    {
      url: @url,
      categories: [{
        listLocation: "for_activity_category",
        maxNumberOfElements: 10,
        header: "Vorlagen von Leistungskategorie"
      }
      ,{
        listLocation: "for_customer",
        maxNumberOfElements: 6,
        header: "Für Kunde zuletzt verwendete Texte"
      }],
      list: {
        maxNumberOfElements: 16,
        match: {
          enabled: true
        },
        hideOnEmptyPhrase: false,
        displayOnFocus: true,
      },
      requestDelay: 600,
    }

  url: (query) ->
    employee = $('#activity_employee_id').val()
    customer = $('#activity_customer_id').val()
    activity_category = $('#activity_activity_category_id').val()
    url = "/activities/suggestions.json?query=#{query}&employee_id=#{employee}" +
            "&customer_id=#{customer}&activity_category_id=#{activity_category}"

jQuery ->
  $('.activities').each (index) ->
    new ActivityTextInput($('#activity_text_input'))

  $('.focus_hours_subject').click(->
    $('#hours_subject_select').select2('open')
  )

  $('#activity_activity_category_id').on("select2:close", ->
    setTimeout( ->
      $("#activity_activity_category_id").focus()
    , 1)
  )
