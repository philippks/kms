class InvoiceMailer < ApplicationMailer
  def invoice_mail(invoice, body)
    @invoice = invoice
    @body = body

    set_attachment

    mail(to: to_address, subject: subject, body: body)
  end

  private

  def set_attachment
    attachments[attachment_filename] = invoice_pdf
  end

  def invoice_pdf
    Invoices::TemplatedPDF.new(
      Invoices::PDF.new(@invoice).read
    ).read
  end

  def attachment_filename
    [
      I18n.t('activerecord.attributes.invoices/mail.attachment_filename'),
      '_',
      @invoice.date,
      '.pdf'
    ].join
  end

  def to_address
    @invoice.customer.email_address
  end

  def subject
    I18n.t 'activerecord.attributes.invoices/mail.subject', date: I18n.l(@invoice.date, format: :long)
  end
end
