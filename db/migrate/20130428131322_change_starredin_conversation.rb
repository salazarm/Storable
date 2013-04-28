class ChangeStarredinConversation < ActiveRecord::Migration
  def up
  	add_column :conversations, :host_starred, :boolean
  	add_column :conversations, :host_read, :boolean
  	add_column :conversations, :renter_starred, :boolean
  	add_column :conversations, :renter_read, :boolean
  end

  def down
  	remove_column :conversations, :is_read
  	remove_column :conversations, :is_starred
  end
end
