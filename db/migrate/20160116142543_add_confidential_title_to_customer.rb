class AddConfidentialTitleToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :confidential_title, :string
  end
end
