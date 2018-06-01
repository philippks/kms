class ChangeEffortAmountToFloat < ActiveRecord::Migration
  def change
    change_column :efforts, :amount, :float
  end
end
