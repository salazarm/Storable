class CreateListings < ActiveRecord::Migration
  def up
  	create_table :listings do |t|
      t.string :title
      t.text :description

      t.integer :user_id

      t.integer :price
      t.float :size
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end

  def down
  end
end
