require "test_helper"

class FaviritesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get favirites_show_url
    assert_response :success
  end
end
