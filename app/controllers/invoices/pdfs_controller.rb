module Invoices
  class PdfsController < ApplicationController
    load_and_authorize_resource :invoice

    def show
      respond_to do |format|
        format.pdf do
          send_data pdf, filename:
        end
      end
    end

    def new
      @invoice = InvoicePresenter.new(@invoice)
      wicked_pdf_config = Global.invoices.wicked_pdf_options.hash.deep_symbolize_keys

      respond_to do |format|
        format.pdf do
          render pdf: filename, layout: false, show_as_html: params[:html], **wicked_pdf_config
        end
      end
    end

    def qr_bill
      @invoice = InvoicePresenter.new(@invoice)
      wicked_pdf_config = Global.invoices.qr_bill_wicked_pdf_options.hash.deep_symbolize_keys

      respond_to do |format|
        format.pdf do
          render pdf: filename, layout: false, show_as_html: params[:html], **wicked_pdf_config
        end
      end
    end

    private

    def pdf
      template_pdf? ? templated_pdf : plain_pdf
    end

    def template_pdf?
      params[:templated] && Global.invoices.company_template_path.present?
    end

    def templated_pdf
      Invoices::TemplatedPDF.new(plain_pdf).read
    end

    def plain_pdf
      Invoices::PDF.new(@invoice).read
    end

    def filename
      "Rechnung #{@invoice.customer.name} #{@invoice.date}.pdf"
    end
  end
end
