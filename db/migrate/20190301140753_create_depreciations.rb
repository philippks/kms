class CreateDepreciations < ActiveRecord::Migration[5.2]
  def change
    create_table :depreciations do |t|
      t.string :note
      t.date :date
      t.integer :persisted_total_amount_cents
      t.references :customer, foreign_key: true
      t.references :employee, foreign_key: true

      t.timestamps
    end

    change_table :efforts do |t|
      t.references :depreciation, foreign_key: true
    end
  end
end
