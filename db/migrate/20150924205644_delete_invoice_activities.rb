class DeleteInvoiceActivities < ActiveRecord::Migration
  def change
    drop_table :invoice_activities
  end
end
