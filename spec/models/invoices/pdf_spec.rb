require 'rails_helper'

describe Invoices::PDF do
  let(:invoice) { create :invoice, :default_associations }
  let(:pdf) { described_class.new(invoice) }
  let(:persisted_pdf_path) { "#{Global.invoices.persisted_pdfs_directory}/#{invoice.id}.pdf" }

  describe '#read' do
    context 'when pdf is persisted' do
      before do
        pdf.persist!
      end

      it 'returns persisted pdf' do
        expect(pdf.read).to eq File.open(persisted_pdf_path).read
      end
    end

    context 'when pdf is not persisted' do
      before do
        pdf.remove_persisted_pdf
      end

      it 'returns newly rendered pdf' do
        expect(pdf.read).to include 'PDF'
      end
    end
  end

  describe '#persist!' do
    before do
      pdf.remove_persisted_pdf
    end

    it 'perists pdf' do
      expect do
        pdf.persist!
      end.to change { File.exist?(persisted_pdf_path) }.from(false).to(true)
    end
  end

  describe '#remove_persisted_pdf' do
    before do
      pdf.persist!
    end

    it 'removes peristed pdf' do
      expect do
        pdf.remove_persisted_pdf
      end.to change { File.exist?(persisted_pdf_path) }.from(true).to(false)
    end
  end
end
