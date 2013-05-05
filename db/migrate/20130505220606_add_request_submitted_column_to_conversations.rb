class AddRequestSubmittedColumnToConversations < ActiveRecord::Migration
  def change
  	add_column :conversations, :request_submitted, :boolean
  end
end
