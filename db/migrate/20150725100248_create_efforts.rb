class CreateEfforts < ActiveRecord::Migration
  def change
    create_table :efforts do |t|
      t.string :type
      t.references :employee, index: true
      t.references :customer, index: true
      t.date :date
      t.string :text
      t.string :note
      t.integer :state, default: 0
      t.integer :amount

      t.float :hours
      t.integer :hourly_rate
      t.references :activity_category, index: true
    end

    add_foreign_key :efforts, :employees
    add_foreign_key :efforts, :customers
    add_foreign_key :efforts, :activity_categories
  end
end
