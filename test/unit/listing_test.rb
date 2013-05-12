require 'test_helper'

class ListingTest < ActiveSupport::TestCase

  #multiple search results
  test "basic search multiple results" do
    results = Listing.search({:address => "77 Mass Ave", :radius => '10'})
    assert_equal results.length, 2
  end

  #no search results since there are no listings near that address
  test "basic search no results" do
    results = Listing.search({:address => "10480 maya linda road", :radius => '1'})
    assert_equal results.length, 0
  end

  #no search results since wrong address
  test " search wrong address no results" do
    results = Listing.search({:address => "blah blah road", :radius => '1'})
    assert_equal results.length, 0
  end


end
