class RemoveWizardStateFromInvoice < ActiveRecord::Migration[5.0]
  def change
    remove_column :invoices, :wizard_state
  end
end
