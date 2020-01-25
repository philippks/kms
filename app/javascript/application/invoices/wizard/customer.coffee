jQuery ->
  $('select.invoice_customer_select').each (index, select) ->
    new CustomerSelect(select, (customer_id) =>
      window.location = urlWithCustomerId(customer_id)
    )

  initializeConfidentialTitleToggler()

urlWithCustomerId = (customer_id) ->
  current_url = window.location.href
  if (current_url.indexOf("customer") >= 0)
    return updateQueryStringParameter(current_url, 'customer_id', customer_id)
  else
    return current_url + "/customer?customer_id=" + customer_id

# from http://stackoverflow.com/a/6021027
updateQueryStringParameter = (uri, key, value) ->
  re = new RegExp('([?&])' + key + '=.*?(&|$)', 'i')
  separator = if uri.indexOf('?') != -1 then '&' else '?'
  if uri.match(re)
    uri.replace re, '$1' + key + '=' + value + '$2'
  else
    uri + separator + key + '=' + value

initializeConfidentialTitleToggler = ->
  confidential_checkbox = $('#invoice_confidential')
  confidential_title = $('.invoice_customer_confidential_title')

  if confidential_checkbox.prop('checked')
    confidential_title.show()
  else
    confidential_title.hide()

  confidential_checkbox.click ->
    confidential_title.toggle()
