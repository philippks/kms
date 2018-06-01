class AddWizardStatusToInvoice < ActiveRecord::Migration
  def change
    change_column :invoices, :wizard_state, :integer, default: -1
  end
end
