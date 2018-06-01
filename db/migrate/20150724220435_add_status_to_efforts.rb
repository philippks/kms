class AddStatusToEfforts < ActiveRecord::Migration
  def change
    add_column :activities, :state, :integer, default: 0
    add_column :expenses, :state, :integer, default: 0
  end
end
