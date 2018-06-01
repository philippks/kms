describe PDFGenerator do
  let(:pdf_generator) { described_class.new }

  class SomePDFGenerator < described_class
    def generate_odt
      # do some odt stuff
    end

    def file_name
      'some_file_name'
    end
  end

  describe '#create' do
    let(:odt_double) { OpenStruct.new path: 'tmp_file.odt' }
    let(:pdf_double) { OpenStruct.new path: 'tmp_file.pdf' }

    subject { SomePDFGenerator.new.create }

    before do
      allow(Rails).to receive(:root).and_return('')

      expect(Tempfile).to receive(:new).with('some_file_name_odt', '/tmp/').and_return odt_double
      expect(Tempfile).to receive(:new).with('some_file_name_pdf', '/tmp/').and_return pdf_double
    end

    it 'converts odt to pdf' do
      expect(Libreconv).to receive(:convert).with('tmp_file.odt', 'tmp_file.pdf')

      subject
    end
  end
end
