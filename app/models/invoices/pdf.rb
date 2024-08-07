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
      invoice_presenter = InvoicePresenter.new(@invoice)

      invoice_pdf = WickedPdf.new.pdf_from_string(
        PdfsController.render(:new, assigns: { invoice: invoice_presenter }),
        **Global.invoices.wicked_pdf_options.hash.deep_symbolize_keys
      )

      qr_bill_pdf = WickedPdf.new.pdf_from_string(
        PdfsController.render(:qr_bill, assigns: { invoice: invoice_presenter }),
        **Global.invoices.qr_bill_wicked_pdf_options.hash.deep_symbolize_keys
      )

      (CombinePDF.parse(invoice_pdf) << CombinePDF.parse(qr_bill_pdf)).to_pdf
    end

    def file_name
      "invoice_#{invoice.date.to_s.underscore}_final"
    end

    def tmp_dir
      "#{Rails.root}/tmp/"
    end
  end
end
