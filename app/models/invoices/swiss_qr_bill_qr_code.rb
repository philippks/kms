module Invoices
  class SwissQrBillQrCode
    def self.generate_img_data_for(invoice)
      qrcode = RQRCode::QRCode.new(qr_code_payload_for(invoice))
      png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 0,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: 'black',
        file: nil,
        fill: 'white',
        module_px_size: 10,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 1024,
      )

      swiss_cross = ChunkyPNG::Image.from_file("app/assets/images/swiss_cross.png")
      final_qr    = png.compose!(swiss_cross, (png.width - swiss_cross.width) / 2,  (png.height - swiss_cross.height) / 2)
      Base64.encode64(final_qr.to_blob)
    end

    private

    def self.qr_code_payload_for(invoice)
      <<~HEREDOC
SPC
0200
1
#{Global.invoices.iban.delete(' ')}
K
#{Global.invoices.receiver.name}
#{Global.invoices.receiver.street}
#{Global.invoices.receiver.postal_code} #{Global.invoices.receiver.city}


#{Global.invoices.receiver.country_code}







#{invoice.total_amount}
#{Global.invoices.currency_symbol}







NON


EPD


      HEREDOC
    end
  end
end
