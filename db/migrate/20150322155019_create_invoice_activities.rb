class CreateInvoiceActivities < ActiveRecord::Migration
  def change
    create_table :invoice_activities do |t|
      t.string :text
      t.integer :amount
      t.references :invoice, index: true

      t.timestamps null: false
    end
    add_foreign_key :invoice_activities, :invoices
  end
end
