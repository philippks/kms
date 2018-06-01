class RenameInvoiceActivityAttributes < ActiveRecord::Migration
  def change
    change_table :invoice_efforts do |t|
      t.rename :hours, :hours_manually
      t.rename :hourly_rate, :hourly_rate_manually
      t.rename :amount, :amount_manually
    end
  end
end
