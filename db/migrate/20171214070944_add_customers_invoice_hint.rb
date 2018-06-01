class AddCustomersInvoiceHint < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :invoice_hint, :string
  end
end
