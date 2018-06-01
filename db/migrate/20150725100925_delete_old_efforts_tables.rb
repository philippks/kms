class DeleteOldEffortsTables < ActiveRecord::Migration
  def change
    drop_table :activities
    drop_table :expenses
  end
end
