require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase
  test "get conversationss for a user when logged in" do
  
    get :index, {:format => 'json'}, {:user_id=>2}

        assert_response 200

        conversations = JSON.parse(@response.body)

        assert_equal 1, conversations.length

    end
end
