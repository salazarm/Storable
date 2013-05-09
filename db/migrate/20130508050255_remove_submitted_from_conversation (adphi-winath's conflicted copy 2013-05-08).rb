class RemoveSubmittedFromConversation < ActiveRecord::Migration
  def change
    remove_column :conversations, :request_submitted
  end
end
