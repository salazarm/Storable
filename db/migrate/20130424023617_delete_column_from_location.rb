class DeleteColumnFromLocation < ActiveRecord::Migration
  def change
    remove_column :locations, :name
  end
end
