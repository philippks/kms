$ ->
  $('.invoices-wizard-summary').each ->
    $('.pdf_viewer').each ->
      new PdfViewer($(@), { scale: 1.2 })
