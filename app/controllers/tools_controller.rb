class ToolsController < ApplicationController
  def index; end

  def combine_pdf
    uploaded_pdf = params[:pdf_file]

    if uploaded_pdf.present?
      templated_pdf = Invoices::TemplatedPDF.new(uploaded_pdf.read).read

      send_data templated_pdf,
                filename: uploaded_pdf.original_filename,
                type: 'application/pdf',
                disposition: 'attachment'
    else
      redirect_to tools_path, alert: 'Bitte wähle eine PDF-Datei aus.'
    end
  end
end
