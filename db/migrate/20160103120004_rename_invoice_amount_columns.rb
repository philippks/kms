class RenameInvoiceAmountColumns < ActiveRecord::Migration
  def change
    change_table :invoices do |t|
      t.rename :activities_amount_manually, :activities_amount_manually
      t.rename :expenses_amount_manually, :expenses_amount_manually
    end
  end
end
