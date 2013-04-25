class ChangeColumnTypeLocation < ActiveRecord::Migration
  def change
    remove_column :locations, :zip
    add_column :locations, :zip, :string
  end
end
