module Invoices
  class TemplatedPDF
    attr_accessor :invoice

    def initialize(invoice_pdf_path)
      @invoice_pdf_path = invoice_pdf_path
    end

    def path
      return @invoice_pdf_path if Global.invoices.company_template_path.blank?

      pdf = CombinePDF.load @invoice_pdf_path
      pdf.pages.first << template_pdf if pdf.pages.any?
      pdf.save output_file.path

      output_file.path
    end

    private

    def template_pdf
      CombinePDF.load(Global.invoices.company_template_path).pages[0]
    end

    def output_file
      @output_file ||= Tempfile.new("#{@invoice_pdf_path.parameterize}_templated.pdf", tmp_dir)
    end

    def tmp_dir
      "#{Rails.root}/tmp/"
    end
  end
end
