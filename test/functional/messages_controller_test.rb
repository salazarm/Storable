require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

    test "create first message for renter when user logged in" do

        post :create, {:format => 'json', :message => {:content => "some test message"}, :listing_id=>1, :message_receiver_id => 1}, {:user_id=>2}
        
        assert_response 201
        assert_equal "application/json", @response.content_type

        message = JSON.parse(@response.body)

        assert_equal "some test message", message["content"]
    end

    test "create response message for host when user logged in" do

        post :create, {:format => 'json', :message => {:content => "hey!"}, :listing_id=>1, :message_receiver_id => 2}, {:user_id=>1}
        
        assert_response 201
        assert_equal "application/json", @response.content_type

        message = JSON.parse(@response.body)

        assert_equal "hey!", message["content"]


    end

end
