class CreateHourlyRates < ActiveRecord::Migration[5.0]
  def change
    create_table :hourly_rates do |t|
      t.references :employee
      t.references :customer
      t.integer :hourly_rate_cents
    end
  end
end
