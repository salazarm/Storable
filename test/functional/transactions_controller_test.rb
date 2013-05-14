require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase

	test "create transaction when user logged in" do

        post :create, {
        	:format => 'json',
        	:listing_id => 1,
        	:user_id => 1,
        	:transaction => {
        		:host_id => "1", 
        		:renter_id => "2", 
        		:stripeToken => "stripeToken", 
        		:start_date => "2013-04-23", 
        		:end_date => "2013-05-23" 
        	}
        }, {:user_id=>1}
        
        assert_response 200
        assert_equal "application/json", @response.content_type

        transaction = JSON.parse(@response.body)

        assert_equal "stripeToken", transaction["stripeToken"]
    end


    test "get transactions when logged in" do
  
        get :index, {:format => 'json', :user_id => 1}, {:user_id=>1}

        assert_response 200
        transactions = JSON.parse(@response.body)

        assert_equal 1, transactions["pending_host_transactions"].length
        assert_equal 1, transactions["past_renter_transactions"].length

    end

    test "get a particular transaction when logged in" do

        get :show, {:format => 'json', :user_id => 1, :id => 1}, {:user_id=>1}
        
        assert_response 200
    end
end