class CreateListingReservedCalendars < ActiveRecord::Migration
  def change
    create_table :listing_reserved_calendars do |t|
      t.integer :listing_id
      t.integer :renter_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
