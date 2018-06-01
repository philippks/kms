class AddVisibleFlagToInvoiceEfforts < ActiveRecord::Migration
  def change
    add_column :invoice_efforts, :visible, :boolean, default: true
  end
end
