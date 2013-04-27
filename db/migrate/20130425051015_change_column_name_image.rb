class ChangeColumnNameImage < ActiveRecord::Migration
  def change
    remove_column :images, :image_url
    add_column :images, :url, :string
  end
end
