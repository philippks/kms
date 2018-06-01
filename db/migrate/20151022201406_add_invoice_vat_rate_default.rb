class AddInvoiceVatRateDefault < ActiveRecord::Migration
  def change
    change_column :invoices, :vat_rate, :float, default: 8.0
  end
end
