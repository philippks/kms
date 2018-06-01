class AddMissingInvoiceAttributes < ActiveRecord::Migration
  def change
    add_column :invoices, :confidential_title, :string
    add_column :invoices, :activities_amount_manually, :integer
    add_column :invoices, :expenses_amount_manually, :integer
    add_column :invoices, :possible_wir_amount, :integer, default: 0
    add_column :invoices, :title, :string
    add_column :invoices, :format, :integer, default: 0
  end
end
