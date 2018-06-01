class RemoveExpensesAmountManually < ActiveRecord::Migration[5.0]
  def change
    remove_column :invoices, :expenses_amount_manually_cents, :integer
  end
end
