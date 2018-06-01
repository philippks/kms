class PDFGenerator
  def create
    generate_odt
    convert_odt_to_pdf
    self
  end

  def pdf_path
    pdf.path
  end

  private

  def convert_odt_to_pdf
    Libreconv.convert odt.path, pdf_path
  end

  def odt
    @odt ||= Tempfile.new "#{file_name}_odt", tmp_dir
  end

  def pdf
    @pdf ||= Tempfile.new "#{file_name}_pdf", tmp_dir
  end

  def tmp_dir
    "#{Rails.root}/tmp/"
  end
end
