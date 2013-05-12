require 'test_helper'

class ListingsControllerTest < ActionController::TestCase


    test "create listing when user logged in" do

        post :create, {:format => 'json', :listing => {:title => "test", :description => "test_desc", :price => "20", :size => "234.00", :start_date=> "2013-04-23", :end_date => "2013-07-23" }}, {:user_id=>1}
        
        assert_response 201
        assert_equal "application/json", @response.content_type

        listing = JSON.parse(@response.body)

        assert_equal "test", listing["title"]
        assert_equal "test_desc", listing["description"]
    end


    test "get listings when logged in" do
  
        get :index, {:format => 'json'}, {:user_id=>1}

        assert_response 200
        listings = JSON.parse(@response.body)

        assert_equal 2, listings.length


    end

    test "get a particular listing when logged in" do

        get :show, {:format => 'json', :id => 1}, {:user_id=>1}

        assert_response 200

    end

    test "update a particular listing when logged in" do

        put :update, {:format => 'json', :id => 1, :listing => {:title => "new"}}, {:user_id=>1}

        assert_response 200

    end

    test "destroy a particular listing when logged in" do

        delete :destroy, {:format => 'json', :id => 1}, {:user_id=>1}

        assert_response 204

    end


end
