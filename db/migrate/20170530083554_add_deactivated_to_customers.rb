class AddDeactivatedToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :deactivated, :bool, default: false
  end
end
