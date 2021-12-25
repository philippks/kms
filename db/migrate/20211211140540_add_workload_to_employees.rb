class AddWorkloadToEmployees < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :workload, :int, null: false, default: 100
  end
end
