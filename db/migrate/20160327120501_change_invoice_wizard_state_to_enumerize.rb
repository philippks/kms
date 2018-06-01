class ChangeInvoiceWizardStateToEnumerize < ActiveRecord::Migration
  def change
    rename_column :invoices, :wizard_state_cd, :wizard_state
  end
end
