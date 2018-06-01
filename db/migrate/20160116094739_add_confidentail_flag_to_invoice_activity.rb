class AddConfidentailFlagToInvoiceActivity < ActiveRecord::Migration
  def change
    add_column :invoice_efforts, :confidential, :bool, default: false
  end
end
