class RenameReservedListing < ActiveRecord::Migration
  def change
     rename_table :reserved_listings, :reserved_dates
  end
end
