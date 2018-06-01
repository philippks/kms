class RemoveAmountManuallyFromInvoiceActivities < ActiveRecord::Migration
  def change
    remove_column :invoice_efforts, :amount_manually
  end
end
