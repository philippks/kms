class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :vat_rates

      t.timestamps
    end
  end
end
