class AddPagebreakToInvoiceEfforts < ActiveRecord::Migration
  def change
    add_column :invoice_efforts, :pagebreak, :boolean, default: false
  end
end
