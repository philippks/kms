module Invoices
  class PDF
    attr_accessor :invoice

    def initialize(invoice)
      @invoice = invoice
    end

    def create_temporary
      if @invoice.confidential?
        main_pdf_generator.create
        confidential_supplement_pdf.create

        @pdf = combine_pdfs [main_pdf_generator.pdf_path, confidential_supplement_pdf.pdf_path]
      else
        main_pdf_generator.create

        @pdf = File.new main_pdf_generator.pdf_path
      end

      return @pdf.path
    end

    def create_persisted
      FileUtils.cp(create_temporary, persisted_pdf_path)
    end

    def persisted?
      File.exists? persisted_pdf_path
    end

    def persisted_pdf_path
      "#{Global.invoices.persisted_pdfs_directory}/#{@invoice.id}.pdf"
    end

    def remove_persisted_pdf
      FileUtils.rm persisted_pdf_path if persisted?
    end

    private

    def main_pdf_generator
      @main_pdf_generator ||= Invoices::PDFGenerators::Main.new @invoice
    end

    def confidential_supplement_pdf
      @confidential_supplement_pdf ||= Invoices::PDFGenerators::ConfidentialSupplement.new @invoice
    end

    def combine_pdfs(pdf_paths)
      output = Tempfile.new("#{file_name}_pdf", tmp_dir)

      combined_pdf = CombinePDF.new
      pdf_paths.each do |pdf_path|
        combined_pdf << CombinePDF.load(pdf_path)
      end
      combined_pdf.save output.path

      output
    end

    def file_name
      "invoice_#{invoice.date.to_s.underscore}_final"
    end

    def tmp_dir
      "#{Rails.root}/tmp/"
    end
  end
end
