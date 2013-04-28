class DeleteIsStarredAndIsReadFromMessage < ActiveRecord::Migration
  def down
  	remove_column :messages, :is_read
  	remove_column :messages, :is_starred
  end
end
