require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
    test "create location for listing when user logged in" do

        post :create, {:format => 'json', :listing_id=>1, :location => {:street => "Mass Ave", :city=> "Cambridge", :state => "MA", :zip => "02142"}}, {:user_id=>1}
        
        assert_response 201
        assert_equal "application/json", @response.content_type

        image = JSON.parse(@response.body)

        assert_equal "Mass Ave", image["street"]
    end

    test "update location for listing when user logged in" do

        put :update, {:format => 'json', :listing_id=>1, :id=>1, :location => {:zip => "02142"}}, {:user_id=>1}
        
        assert_response 204
    end

    test "destroy location for listing when user logged in" do
        delete :destroy, {:format => 'json', :listing_id=>1, :id => 1}, {:user_id=>1}

        assert_response 204
    end

    test "update location for listing that this user doesnt own when user logged in" do

        assert_raises(ActiveRecord::RecordNotFound) do
            put :update, {:format => 'json', :listing_id=>2, :id=>1, :location => {:zip => "02142"}}, {:user_id=>1}
        end
    end

end
