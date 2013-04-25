class DeleteNameFromConversaion < ActiveRecord::Migration
  def change
    remove_column :conversations, :name
  end
end
