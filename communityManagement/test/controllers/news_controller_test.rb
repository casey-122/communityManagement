require 'test_helper'

class NewsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get news_create_url
    assert_response :success
  end

end
