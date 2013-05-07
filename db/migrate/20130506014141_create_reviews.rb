class CreateReviews < ActiveRecord::Migration
  def up
  	create_table :reviews do |t|

      
      # common attributes
      t.integer :reviewer_id
      t.text :content
      t.integer :overall_rating
      t.integer :quality_rating
      t.timestamps

      # parameters for transaction reviews
      t.integer :transaction_id
      t.integer :location_rating
      t.integer :price_rating

      # parameters for user reviews
      t.integer :reviewee_id
      t.integer :timeliness_rating
      t.integer :responsiveness_rating

      # required for STI
      t.string :type
      
    end
  end

  def down
  end
end
