require 'test_helper'

class ListingTest < ActiveSupport::TestCase
  test "basic search multiple results" do
    results = Listing.search({:address => "77 Mass Ave", :radius => '10'})
    assert_equal results.length, 2
  end
end
