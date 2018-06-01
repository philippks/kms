class ChangeFloatColumnsToDecimal < ActiveRecord::Migration[5.1]
  def up
    change_column :absences, :hours, :decimal
    change_column :efforts, :hours, :decimal
    change_column :invoice_efforts, :hours_manually, :decimal
    change_column :invoices, :vat_rate, :decimal

    change_column :efforts, :amount_cents, :integer
    change_column :invoices, :persisted_total_amount_cents, :integer
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
