class RefactorTotalAmounts < ActiveRecord::Migration[5.1]
  def change
    rename_column :invoices, :persisted_amount_cents, :persisted_total_amount_cents

    Invoice.all.each do |invoice|
      invoice.persist_total_amount
    end
  end
end
