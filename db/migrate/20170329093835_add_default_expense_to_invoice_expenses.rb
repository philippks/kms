class AddDefaultExpenseToInvoiceExpenses < ActiveRecord::Migration[5.0]
  def change
    add_column :invoice_efforts, :default_expense, :bool, default: false
  end
end
