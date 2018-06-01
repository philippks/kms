class RenameInvoiceStatusToState < ActiveRecord::Migration
  def change
    rename_column :invoices, :wizard_status_cd, :wizard_state_cd
    rename_column :efforts, :status, :state
  end
end
