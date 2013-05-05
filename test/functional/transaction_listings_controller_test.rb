require 'test_helper'

class TransactionListingsControllerTest < ActionController::TestCase
  setup do
    @transaction_listing = transaction_listings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transaction_listings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transaction_listing" do
    assert_difference('TransactionListing.count') do
      post :create, transaction_listing: { description: @transaction_listing.description, end_date: @transaction_listing.end_date, price: @transaction_listing.price, size: @transaction_listing.size, start_date: @transaction_listing.start_date, title: @transaction_listing.title, user_id: @transaction_listing.user_id }
    end

    assert_redirected_to transaction_listing_path(assigns(:transaction_listing))
  end

  test "should show transaction_listing" do
    get :show, id: @transaction_listing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transaction_listing
    assert_response :success
  end

  test "should update transaction_listing" do
    put :update, id: @transaction_listing, transaction_listing: { description: @transaction_listing.description, end_date: @transaction_listing.end_date, price: @transaction_listing.price, size: @transaction_listing.size, start_date: @transaction_listing.start_date, title: @transaction_listing.title, user_id: @transaction_listing.user_id }
    assert_redirected_to transaction_listing_path(assigns(:transaction_listing))
  end

  test "should destroy transaction_listing" do
    assert_difference('TransactionListing.count', -1) do
      delete :destroy, id: @transaction_listing
    end

    assert_redirected_to transaction_listings_path
  end
end
