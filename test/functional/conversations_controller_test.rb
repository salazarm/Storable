require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  test "get conversations for a listing when logged in" do
  
    get :index, {:format => 'json', :listing_id=>1}, {:user_id=>1}

        assert_response 200
        conversations = JSON.parse(@response.body)

        assert_equal 1, conversations.length
        assert_equal 2, conversations[0]['messages'].length

    end
end
