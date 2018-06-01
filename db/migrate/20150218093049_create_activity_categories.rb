class CreateActivityCategories < ActiveRecord::Migration
  def change
    create_table :activity_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
