class ChangeDefaultForTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :host_seen
    remove_column :transactions, :host_accepted

    add_column :transactions, :host_seen, :boolean, :default => false
    add_column :transactions, :host_accepted, :boolean, :default => false
  end

end
