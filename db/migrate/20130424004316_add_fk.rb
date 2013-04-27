class AddFk < ActiveRecord::Migration
  def change
    add_column :conversations, :listing_id, :integer
  end
end
