class AddNotChargeableToCustomerGroups < ActiveRecord::Migration
  def change
    add_column :customer_groups, :not_chargeable, :boolean, default: false
  end
end
