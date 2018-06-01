require 'rails_helper'

describe Invoices::TemplatedPDF do
  describe 'path' do
    subject { described_class.new(path).path }

    let(:path) { 'tmp/invoice.pdf' }
    let(:templated_pdf_double) { instance_double Tempfile }

    before do
      FileUtils.touch(path)

      allow(Tempfile).to receive(:new).with(
        'tmp-invoice-pdf_templated.pdf', "#{Rails.root}/tmp/"
      ).and_return templated_pdf_double

      allow(templated_pdf_double).to receive(:path).and_return 'tmp/templated_pdf.pdf'
    end

    it 'returns templated pdf path' do
      expect(subject).to eq 'tmp/templated_pdf.pdf'
    end

    context 'if company templated disabled' do
      before do
        expect(Global.invoices).to receive(:company_template_path).and_return nil
      end

      it 'returns default pdf path' do
        expect(subject).to eq path
      end
    end
  end
end
