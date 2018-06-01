class CreateInvoiceMail < ActiveRecord::Migration[5.1]
  def change
    create_table :invoice_mails do |t|
      t.string :from
      t.string :to
      t.string :body
      t.references :invoice, index: true
      t.references :employee, index: true
    end

    add_foreign_key :invoice_mails, :invoices
    add_foreign_key :invoice_mails, :employees
  end
end
