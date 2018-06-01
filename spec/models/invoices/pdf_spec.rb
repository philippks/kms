require 'rails_helper'

describe Invoices::PDF do
  let(:invoice) { create :invoice, :default_associations }
  let(:pdf) { described_class.new(invoice) }

  describe 'create' do
    let(:main_pdf_generator) { double }
    let(:pdf_double) { OpenStruct.new id: 1337, path: 'main.pdf' }

    before do
      expect(Invoices::PDFGenerators::Main).to receive(:new).with(invoice).and_return main_pdf_generator
      expect(main_pdf_generator).to receive(:pdf_path).and_return 'main.pdf'
      expect(main_pdf_generator).to receive(:create)
      expect(File).to receive(:new).with('main.pdf').and_return pdf_double
    end

    describe '#create_temporary' do
      subject { pdf.create_temporary }

      it 'returns created pdf path' do
        expect(subject).to eq('main.pdf')
      end
    end

    describe '#create_persisted' do
      subject { pdf.create_persisted }

      it 'copies temporary created pdf to persisted location' do
        expect(FileUtils).to receive(:cp).with(
          'main.pdf', "#{Global.invoices.persisted_pdfs_directory}/#{invoice.id}.pdf"
        )

        subject
      end
    end
  end
end
