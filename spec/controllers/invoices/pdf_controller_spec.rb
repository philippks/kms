require 'rails_helper'

RSpec.describe Invoices::PdfsController do
  let(:customer) { create :customer, name: 'Hans' }
  let(:employee) { create :employee }
  let!(:invoice) { create :invoice, customer: customer, employee: employee, date: '2017-09-04' }

  before do
    sign_in employee
  end

  describe 'GET #show' do
    let(:pdf_double) { instance_double Invoices::PDF }
    let(:pdf_data) { double('data') }

    before do
      allow(Invoices::PDF).to receive(:new).and_return pdf_double
      allow(pdf_double).to receive(:read).and_return pdf_data
      allow(pdf_double).to receive(:persisted?).and_return true
      allow(pdf_double).to receive(:persisted_pdf_path).and_return 'persisted.pdf'
    end

    it 'returns pdf path' do
      expect(controller).to receive(:send_data).with(pdf_data, filename: 'Rechnung Hans 2017-09-04.pdf')

      get :show, format: :pdf, params: { invoice_id: invoice.to_param }
    end

    context 'with templated = true' do
      let(:templated_pdf_double) { instance_double Invoices::TemplatedPDF }
      let(:templated_pdf_data) { double('templated data') }

      it 'returns templated pdf path' do
        expect(Invoices::TemplatedPDF).to receive(:new).with(pdf_data).and_return templated_pdf_double
        allow(templated_pdf_double).to receive(:read).and_return templated_pdf_data

        expect(controller).to receive(:send_data).with(templated_pdf_data, filename: 'Rechnung Hans 2017-09-04.pdf')

        get :show, format: :pdf, params: { templated: true, invoice_id: invoice.to_param }
      end
    end
  end
end
