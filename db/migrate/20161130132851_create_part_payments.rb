class CreatePartPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :part_payments do |t|
      t.date :date, null: false
      t.integer :amount_cents, null: false
      t.references :invoice, index: true

      t.timestamps
    end
    add_foreign_key :part_payments, :invoices
  end
end
