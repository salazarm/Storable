class DeleteColumnSubjectFromMessages < ActiveRecord::Migration
  def down
  	remove_column :messages, :title
  end
end
