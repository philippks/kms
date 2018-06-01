class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.date :date
      t.string :address
      t.float :vat_rate
      t.references :employee, index: true
      t.references :customer, index: true

      t.timestamps null: false
    end
    add_foreign_key :invoices, :employees
    add_foreign_key :invoices, :customers
  end
end
