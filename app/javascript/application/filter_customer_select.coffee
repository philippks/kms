jQuery ->
  $('select.filter_customer_select').each (index, select) ->
    new CustomerSelect(select, (customer_id) =>
      $(select).closest('form').submit()
    )
