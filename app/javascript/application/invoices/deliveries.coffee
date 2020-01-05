class EmailAddressToggler
  constructor: ->
    @delivery_select = $('#delivery_customer_attributes_invoice_delivery')
    @toggle_elements = $('.toggle')

    @delivery_select.change =>
      @toggle()

    @toggle()

  toggle: () ->
    if @delivery_select.val() == 'email'
      @toggle_elements.show()
    else
      @toggle_elements.hide()

jQuery ->
  new EmailAddressToggler()
