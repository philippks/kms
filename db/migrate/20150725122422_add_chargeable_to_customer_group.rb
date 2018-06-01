class AddChargeableToCustomerGroup < ActiveRecord::Migration
  def change
    add_column :customer_groups, :chargeable, :boolean, default: true
  end
end
