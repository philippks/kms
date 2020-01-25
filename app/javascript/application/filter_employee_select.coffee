jQuery ->
  $('select.filter_employee_select').each (index, select) ->
    new EmployeeSelect(select, (employee_id) =>
      $(select).closest('form').submit()
    )
