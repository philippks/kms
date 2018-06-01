class Invoices::PdfsController < ApplicationController
  load_and_authorize_resource :invoice

  def index
  end

  def new
    respond_to do |format|
      format.pdf do
        send_file pdf_path(templated: params[:templated]), filename: filename
      end
    end
  end

  private

  def pdf_path(templated: false)
    pdf = Invoices::PDF.new(@invoice)
    path = pdf.persisted? ? pdf.persisted_pdf_path : pdf.create_temporary

    templated ? Invoices::TemplatedPDF.new(path).path : path
  end

  def filename
    "Rechnung #{@invoice.customer.name} #{@invoice.date.to_s}.pdf"
  end
end
