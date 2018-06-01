class AddCustomerToCustomerGroup < ActiveRecord::Migration
  def change
    add_column :customers, :customer_group_id, :integer
    add_index :customers, :customer_group_id
  end
end
