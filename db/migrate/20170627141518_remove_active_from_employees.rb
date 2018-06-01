class RemoveActiveFromEmployees < ActiveRecord::Migration[5.1]
  def change
    remove_column :employees, :active
  end
end
