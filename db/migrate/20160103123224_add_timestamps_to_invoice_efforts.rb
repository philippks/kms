class AddTimestampsToInvoiceEfforts < ActiveRecord::Migration
  def change
    add_column :invoice_efforts, :created_at, :datetime
    add_column :invoice_efforts, :updated_at, :datetime
  end
end
