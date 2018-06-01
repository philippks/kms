class ChangeInvoiceWizardStatusBack < ActiveRecord::Migration
  def change
    change_column :invoices, :wizard_state, :integer, default: 0
  end
end
