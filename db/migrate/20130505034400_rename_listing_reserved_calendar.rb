class RenameListingReservedCalendar < ActiveRecord::Migration
  def change
     rename_table :listing_reserved_calendars, :reserved_listings
  end

end
