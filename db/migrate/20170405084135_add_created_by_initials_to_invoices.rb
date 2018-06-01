class AddCreatedByInitialsToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :created_by_initials, :string
  end
end
