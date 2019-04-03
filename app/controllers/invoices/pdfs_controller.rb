class Invoices::PdfsController < ApplicationController
  load_and_authorize_resource :invoice

  def new
    @invoice = InvoicePresenter.new(@invoice)

    respond_to do |format|
      format.html do
        render :new, formats: [:pdf]
      end

      format.pdf do
        render pdf: filename, **Global.invoices.wicked_pdf_options.hash.deep_symbolize_keys
      end
    end
  end

  def show
    respond_to do |format|
      format.pdf do
        send_data pdf, filename: filename
      end
    end
  end

  private

  def pdf
    template_pdf? ? templated_pdf : plain_pdf
  end

  def template_pdf?
    params[:templated] && !Global.invoices.company_template_disabled?
  end

  def templated_pdf
    Invoices::TemplatedPDF.new(plain_pdf).read
  end

  def plain_pdf
    Invoices::PDF.new(@invoice).read
  end

  def filename
    "Rechnung #{@invoice.customer.name} #{@invoice.date.to_s}.pdf"
  end
end
