class AddPersistedAmountToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :persisted_total_amount, :float
  end
end
