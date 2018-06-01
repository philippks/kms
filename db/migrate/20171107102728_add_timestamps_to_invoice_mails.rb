class AddTimestampsToInvoiceMails < ActiveRecord::Migration[5.1]
  def change
    add_column :invoice_mails, :created_at, :datetime
    add_column :invoice_mails, :updated_at, :datetime
  end
end
