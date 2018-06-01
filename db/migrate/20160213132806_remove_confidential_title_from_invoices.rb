class RemoveConfidentialTitleFromInvoices < ActiveRecord::Migration
  def change
    remove_column :invoices, :confidential_title, :string
    remove_column :invoices, :address, :string
  end
end
