class CreateCustomerGroups < ActiveRecord::Migration
  def change
    create_table :customer_groups do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
