module Invoices
  class TemplatedPDF
    def initialize(pdf)
      @pdf = pdf
    end

    def read
      pdf = CombinePDF.parse @pdf
      pdf.pages.first << pdf_template if pdf.pages.any?
      pdf.to_pdf
    end

    private

    def pdf_template
      CombinePDF.load(Global.invoices.company_template_path).pages[0]
    end
  end
end
