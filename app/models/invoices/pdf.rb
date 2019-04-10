module Invoices
  class PDF
    attr_accessor :invoice

    def initialize(invoice)
      @invoice = invoice
    end

    def read
      if persisted?
        File.open(persisted_pdf_path).read
      else
        render_pdf
      end
    end

    def persist!
      File.open(persisted_pdf_path, 'wb') do |file|
        file << render_pdf
      end
    end

    def persisted_pdf_path
      "#{Global.invoices.persisted_pdfs_directory}/#{@invoice.id}.pdf"
    end

    def persisted?
      File.exist? persisted_pdf_path
    end

    def remove_persisted_pdf
      FileUtils.rm persisted_pdf_path if persisted?
    end

    private

    def render_pdf
      @invoice = InvoicePresenter.new(@invoice)

      WickedPdf.new.pdf_from_string(
        PdfsController.render(:new, assigns: { invoice: @invoice }),
        Global.invoices.wicked_pdf_options.hash
      )
    end

    def file_name
      "invoice_#{invoice.date.to_s.underscore}_final"
    end

    def tmp_dir
      "#{Rails.root}/tmp/"
    end
  end
end
