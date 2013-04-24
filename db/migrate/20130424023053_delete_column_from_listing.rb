class DeleteColumnFromListing < ActiveRecord::Migration
  def change
    remove_column :locations, :street_1
    remove_column :locations, :street_2
    add_column :locations, :street, :string
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :zip, :integer
  end
end
