class RenamePartPayments < ActiveRecord::Migration[5.0]
  def change
    rename_table :invoice_part_payments, :invoice_payments
  end
end
