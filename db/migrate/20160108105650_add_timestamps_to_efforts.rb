class AddTimestampsToEfforts < ActiveRecord::Migration
  def change
    add_column :efforts, :created_at, :datetime
    add_column :efforts, :updated_at, :datetime
  end
end
