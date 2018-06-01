class AddInvoiceEffortToEffort < ActiveRecord::Migration
  def change
    add_column :efforts, :invoice_effort_id, :integer
    add_index :efforts, :invoice_effort_id
  end
end
