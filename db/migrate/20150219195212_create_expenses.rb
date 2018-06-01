class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.references :employee, index: true
      t.references :customer, index: true
      t.date :date
      t.integer :amount
      t.string :text
      t.string :note

      t.timestamps null: false
    end
    add_foreign_key :expenses, :employees
    add_foreign_key :expenses, :customers
  end
end
