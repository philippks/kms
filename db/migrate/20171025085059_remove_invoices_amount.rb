class RemoveInvoicesAmount < ActiveRecord::Migration[5.1]
  def change
    remove_column :invoices, :amount
  end
end
