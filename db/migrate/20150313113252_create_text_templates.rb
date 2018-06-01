class CreateTextTemplates < ActiveRecord::Migration
  def change
    create_table :text_templates do |t|
      t.string :text
      t.references :activity_category, index: true

      t.timestamps null: false
    end
    add_foreign_key :text_templates, :activity_categories
  end
end
