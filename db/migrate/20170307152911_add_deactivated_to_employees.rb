class AddDeactivatedToEmployees < ActiveRecord::Migration[5.0]
  def change
    add_column :employees, :deactivated, :bool, default: false
  end
end
