$ ->
  $('.invoices-wizard-activities').each ->
    $('input.submit-button').click ->
      $('form.edit_invoice').submit()

  $('.invoices-wizard-activities, .invoices-wizard-expenses').each (index, element) ->
    initSortables()
    initEditables()

initSortables = () ->
  sortables = sortable('.sortable', {
    items: 'tr',
    placeholder: '<tr><td colspan="10">&nbsp;</td></tr>',
    forcePlaceholderSize: true,
  })

  $(sortables).on('sortupdate', (event) ->
    path = $(event.detail.item).data('reorder_path')
    id = path.match(/(\d+)\/reorder/)[1]

    $.ajax({
      url: path,
      data: {
        id: id,
        activity: {
          position: event.detail.destination.index + 1
        }
      },
      type: "PATCH"
    })
  )


initEditables = ->
  $('td.hourly_rate .editable, td.hours .editable, td.amount .editable').editable({
    mode: 'popup'
    unsavedclass: null
    emptytext: ->
      if $(this).data('data-success')
        return '...'
      else
        return 'Konflikt'
    success: ->
      $(this).data('data-success', true)
      location.reload()
    error: ->
  })
  $('td.text .editable').editable({
    mode: 'inline'
    unsavedclass: null,
    emptytext: 'Kein Text',
    inputclass: 'invoice_effort_textarea'
  }).on('shown', (e, editable) ->
    invoice_activity_id = $($(this).context).data('invoice-activity-id')

    if invoice_activity_id
      # 💩
      template_link = $(".activity_text_suggestions_#{invoice_activity_id}").clone()
      template_link.appendTo($("tr.invoice-activity-#{invoice_activity_id}").find('.editable-buttons'))
      template_link.removeClass('hidden')

      new InvoiceEffortTextInput($('.invoice_effort_textarea'), invoice_activity_id)
  )

class @InvoiceEffortTextInput
  constructor: (selector, invoice_activity_id) ->
    @url = @url_for(invoice_activity_id)
    @initialize(selector)

  initialize: (selector) ->
    $(selector).easyAutocomplete(@options())

  options: ->
    {
      url: @url,
      requestDelay: 600,
      list: {
        maxNumberOfElements: 16,
        hideOnEmptyPhrase: false,
        displayOnFocus: true,
      },
      categories: [{
        maxNumberOfElements: 8,
        listLocation: "assigned_to_invoice_activity",
        header: "Der Rechnungsleistung zugeordnete Leistungen"
      },{
        maxNumberOfElements: 8,
        listLocation: "previous_invoice_activites",
        header: "Frühere Rechnungsleistungen dieses Kunden"
      },
      ],
    }

  url_for: (invoice_activity_id) ->
    (query) ->
      "/invoices/activities/suggestions.json?query=#{query}" +
        "&invoice_activity_id=#{invoice_activity_id}"
