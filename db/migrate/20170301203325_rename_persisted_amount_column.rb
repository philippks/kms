class RenamePersistedAmountColumn < ActiveRecord::Migration[5.0]
  def change
    change_table :invoices do |t|
      t.rename :persisted_total_amount, :persisted_total_amount_cents
    end
  end
end
