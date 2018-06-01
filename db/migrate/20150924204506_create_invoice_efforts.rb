class CreateInvoiceEfforts < ActiveRecord::Migration
  def change
    create_table :invoice_efforts do |t|
      t.string :type
      t.string :text
      t.integer :amount
      t.references :invoice, index: true

      t.float :hours
      t.integer :hourly_rate
    end

    add_foreign_key :invoice_efforts, :invoices
  end
end
