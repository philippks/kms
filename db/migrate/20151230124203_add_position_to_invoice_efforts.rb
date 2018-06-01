class AddPositionToInvoiceEfforts < ActiveRecord::Migration
  def change
    add_column :invoice_efforts, :position, :integer
  end
end
