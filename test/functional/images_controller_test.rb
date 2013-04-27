require 'test_helper'

class ImagesControllerTest < ActionController::TestCase

    #######tests for user images

    test "create image for user when user logged in" do

        post :create, {:format => 'json', :user_id=>1, :image => {:location => "test.com"}}, {:user_id=>1}
        
        assert_response 201
        assert_equal "application/json", @response.content_type

        image = JSON.parse(@response.body)

        assert_equal "test.com", image["location"]
    end

    test "update image for user when user logged in" do

        put :update, {:format => 'json', :user_id=>1, :id=>3, :image => {:location => "test2.com"}}, {:user_id=>1}
        
        assert_response 204
    end

    test "destroy image for user when user logged in" do
        delete :destroy, {:format => 'json', :user_id=>1, :id => 3}, {:user_id=>1}

        assert_response 204

    end


    #######tests for listing images

    test "create image for listing when user logged in" do

        post :create, {:format => 'json', :listing_id=>1, :image => {:location => "test.com"}}, {:user_id=>1}
        
        assert_response 201
        assert_equal "application/json", @response.content_type

        image = JSON.parse(@response.body)

        assert_equal "test.com", image["location"]
    end

    test "update image for listing when user logged in" do

        put :update, {:format => 'json', :listing_id=>1, :id=>1, :image => {:location => "test222.com"}}, {:user_id=>1}
        
        assert_response 204
    end

    test "destroy image for listing when user logged in" do
        delete :destroy, {:format => 'json', :listing_id=>1, :id => 1}, {:user_id=>1}

        assert_response 204

    end


end
