jQuery ->
  $(':checkbox#checkAll').click( ->
    if (this.checked)
      $(':checkbox').each ->
        $(this).prop('checked', true)
    else
      $(':checkbox').each ->
        $(this).prop('checked', false)
  )
