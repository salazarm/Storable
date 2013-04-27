class ChangeColumnNameImage2 < ActiveRecord::Migration
  def change
    remove_column :images, :url
    add_column :images, :location, :string
  end
end
