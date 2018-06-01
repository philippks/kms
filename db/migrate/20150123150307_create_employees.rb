class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :initials
      t.integer :hourly_rate
      t.integer :worktime_model, default: 0

      t.timestamps null: false
    end
  end
end
