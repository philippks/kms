class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :text
      t.string :note
      t.references :employee, index: true
      t.references :customer, index: true
      t.references :activity_category, index: true
      t.float :hours
      t.integer :hourly_rate
      t.date :date

      t.timestamps null: false
    end
    add_foreign_key :activities, :employees
    add_foreign_key :activities, :customers
    add_foreign_key :activities, :activity_categories
  end
end
