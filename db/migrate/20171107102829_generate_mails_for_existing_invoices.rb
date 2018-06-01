class GenerateMailsForExistingInvoices < ActiveRecord::Migration[5.1]
  def up
    Invoice.where(delivery_method: :email).each do |invoice|
      Invoices::Mail.new(
        from: Global.mailer.from,
        to: invoice.customer.email_address,
        body: body_for(invoice),
        employee: Employee.find(16),
        invoice: invoice,
      ).save!
    end
  end

  def down
    Invoices::Mail.all.destroy_all
  end

  def body_for(invoice)
    template = Rails.root.join('app', 'views', 'invoices', 'mails', 'body.text.erb')
    @invoice = invoice
    ERB.new(File.read(template)).result(binding)
  end
end
