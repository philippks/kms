class ChangeInvoiceWizardStatusToSimpleEnum < ActiveRecord::Migration
  def change
    rename_column :invoices, :wizard_state, :wizard_state_cd
  end
end
