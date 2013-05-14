require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase

    #get reviews when logged in
    test "get reviews when logged in" do
  
        get :index, {:format => 'json', :listing_id=>1, :type => 'TransactionReview'}, {:user_id=>1}

        assert_response 200
        transaction = JSON.parse(@response.body)

        assert_equal 1, transaction.length
        assert_equal "some review", transaction[0]["content"]

    end

    #create a review when logged in
    test "create review when logged in" do
        post :create, {
            :format => 'json',
            :listing_id => 2,
            :type => 'TransactionReview',
            :review => {
                :content => "test"
            }
        }, {:user_id=>4}
        
        assert_response 201
        assert_equal "application/json", @response.content_type

        transaction = JSON.parse(@response.body)

        assert_equal "test", transaction["content"]

    end

     #create a review when you haven't yet had a transaction
     #with a particular listing
    test "create invalid review when logged in" do

        assert_raise(ActiveRecord::RecordNotFound){

            post :create, {
                :format => 'json',
                :listing_id => 3,
                :type => 'TransactionReview',
                :review => {
                    :content => "test"
                }
            }, {:user_id=>4}
        }
        
        
        

    end


    
end