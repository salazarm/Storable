class AddIsStarredAndIsReadToConversations < ActiveRecord::Migration
  def change
  	add_column :conversations, :is_read, :boolean
  	add_column :conversations, :is_starred, :boolean
  end
end
