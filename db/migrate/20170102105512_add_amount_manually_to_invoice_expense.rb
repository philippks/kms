class AddAmountManuallyToInvoiceExpense < ActiveRecord::Migration[5.0]
  def change
    add_column :invoice_efforts, :amount_manually_cents, :integer
  end
end
