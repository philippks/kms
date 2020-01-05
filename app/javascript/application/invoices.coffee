$ ->
  $('.invoices-show').each ->
    $('.pdf_viewer').each ->
      new PdfViewer($(@), { scale: 1 })
