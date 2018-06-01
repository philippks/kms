class CreateTargetHours < ActiveRecord::Migration
  def change
    create_table :target_hours do |t|
      t.date :date
      t.integer :hours, default: 0

      t.timestamps null: false
    end
  end
end
