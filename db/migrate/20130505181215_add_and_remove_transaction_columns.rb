class AddAndRemoveTransactionColumns < ActiveRecord::Migration
  def up
  	add_column :transactions, :host_id, :integer
  	add_column :transactions, :renter_id, :integer
  end

  def down
  end
end
