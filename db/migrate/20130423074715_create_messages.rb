class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|

      t.integer :conversation_id

      t.integer :user_id

      t.text :content
      t.boolean :is_starred
      t.boolean :is_read
      
      
      t.timestamps
    end
  end
end