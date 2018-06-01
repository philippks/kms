class RenameMonetizeAttributes < ActiveRecord::Migration
  def change

    change_table :efforts do |t|
      t.rename :amount, :amount_cents
      t.rename :hourly_rate, :hourly_rate_cents
    end

    change_table :employees do |t|
      t.rename :hourly_rate, :hourly_rate_cents
    end
  end

  change_table :invoice_efforts do |t|
    t.rename :hourly_rate_manually, :hourly_rate_manually_cents
  end

  change_table :invoices do |t|
    t.rename :activities_amount_manually, :activities_amount_manually_cents
    t.rename :expenses_amount_manually, :expenses_amount_manually_cents
    t.rename :possible_wir_amount, :possible_wir_amount_cents
  end
end
