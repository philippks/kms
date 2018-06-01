class RemoveVatRateDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default :invoices, :vat_rate, from: 8.0, to: nil
    change_column_null :invoices, :vat_rate, false
  end
end
