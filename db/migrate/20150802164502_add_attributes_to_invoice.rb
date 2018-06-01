class AddAttributesToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :confidential, :boolean, default: false
    add_column :invoices, :display_swift, :boolean, default: false
    add_column :invoices, :amount, :integer
    add_column :invoices, :state, :integer, default: 0
  end
end
