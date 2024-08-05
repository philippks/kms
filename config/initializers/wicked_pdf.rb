# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

WickedPdf.configure do |c|
  # Path to the wkhtmltopdf executable:
  c.exe_path = '/usr/bin/wkhtmltopdf'

  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  c.layout = 'pdf'

  c.encoding = 'utf-8'
  c.size = 'A4'
  c.footer = { right: '[page] / [topage]' }
end
