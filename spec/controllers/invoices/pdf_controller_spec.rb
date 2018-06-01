require 'rails_helper'

RSpec.describe Invoices::PdfsController do
  let(:customer) { create :customer, name: 'Hans' }
  let(:employee) { create :employee }
  let!(:invoice) { create :invoice, customer: customer, employee: employee, date: '2017-09-04' }

  before do
    sign_in employee
  end

  describe 'GET #new' do
    let(:pdf_double) { instance_double Invoices::PDF }

    before do
      allow(Invoices::PDF).to receive(:new).and_return pdf_double
      allow(pdf_double).to receive(:persisted?).and_return true
      allow(pdf_double).to receive(:persisted_pdf_path).and_return 'persisted.pdf'
    end

    it 'returns pdf path' do
      expect(controller).to receive(:send_file).with('persisted.pdf', filename: 'Rechnung Hans 2017-09-04.pdf')

      get :new, format: :pdf, params: { invoice_id: invoice.to_param }
    end

    context 'with not persisted pdf' do
      before do
        expect(pdf_double).to receive(:persisted?).and_return false
        expect(pdf_double).to receive(:create_temporary).and_return 'temporary.pdf'
      end

      it 'returns temporary pdf path' do
        expect(controller).to receive(:send_file).with('temporary.pdf', filename: 'Rechnung Hans 2017-09-04.pdf')

        get :new, format: :pdf, params: { invoice_id: invoice.to_param }
      end
    end

    context 'with templated = true' do
      let(:templated_pdf_double) { instance_double Invoices::TemplatedPDF }

      it 'returns templated pdf path' do
        expect(Invoices::TemplatedPDF).to receive(:new).with('persisted.pdf').and_return templated_pdf_double
        expect(templated_pdf_double).to receive(:path).and_return 'templated.pdf'

        expect(controller).to receive(:send_file).with('templated.pdf', filename: 'Rechnung Hans 2017-09-04.pdf')

        get :new, format: :pdf, params: { templated: true, invoice_id: invoice.to_param }
      end
    end
  end
end
