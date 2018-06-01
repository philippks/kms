class RenamePartPaymentsColumn < ActiveRecord::Migration[5.0]
  def change
    rename_table :part_payments, :invoice_part_payments
  end
end
