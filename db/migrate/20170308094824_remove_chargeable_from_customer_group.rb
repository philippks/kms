class RemoveChargeableFromCustomerGroup < ActiveRecord::Migration[5.0]
  def change
    remove_column :customer_groups, :chargeable
  end
end
