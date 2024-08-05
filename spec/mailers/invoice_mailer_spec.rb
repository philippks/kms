require 'rails_helper'

describe InvoiceMailer do
  describe 'invoice_mail' do
    subject(:mail) { described_class.invoice_mail(invoice, body) }

    let(:customer) { create :customer, email_address: 'hans@muster.ch' }
    let(:employee) { create :employee }
    let(:invoice) { create :invoice, customer:, employee:, date: '2017-09-04' }
    let(:body) { 'Gruezi' }

    before do
      FileUtils.touch Invoices::PDF.new(invoice).persisted_pdf_path
    end

    it 'renders headers' do
      expect(mail.subject).to eq 'Rechnung vom 4. September 2017'
      expect(mail.to).to eq ['hans@muster.ch']
      expect(mail.from).to eq ['invoices@kms.ch']
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include 'Gruezi'
    end

    it 'attachs the invoice pdf' do
      attachment = mail.attachments[0]

      expect(attachment.content_type).to start_with 'application/pdf'
      expect(attachment.filename).to eq 'Rechnung_2017-09-04.pdf'
    end
  end
end
