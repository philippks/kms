class CreateAbsences < ActiveRecord::Migration
  def change
    create_table :absences do |t|
      t.references :employee, index: true
      t.date :from_date
      t.date :to_date
      t.float :hours
      t.integer :reason
      t.string :text

      t.timestamps null: false
    end
    add_foreign_key :absences, :employees
  end
end
