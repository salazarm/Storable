class CreateLocations < ActiveRecord::Migration
  def up
  	create_table :locations do |t|
      t.string :name
      
      t.integer :listing_id

      t.string :street_1
      t.string :street_2

      t.timestamps
    end
  end

  def down
  end
end
