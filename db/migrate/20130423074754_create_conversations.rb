class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :name
      
      t.integer :renter_id
      t.integer :host_id
      
      t.timestamps
    end
  end
end