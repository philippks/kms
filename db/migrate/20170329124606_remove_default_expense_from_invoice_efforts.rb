class RemoveDefaultExpenseFromInvoiceEfforts < ActiveRecord::Migration[5.0]
  def change
    remove_column :invoice_efforts, :default_expense
  end
end
