require "test_helper"

class AnalysesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get analyses_new_url
    assert_response :success
  end

  test "should get create" do
    get analyses_create_url
    assert_response :success
  end

  test "should get show" do
    get analyses_show_url
    assert_response :success
  end

  test "should get destroy" do
    get analyses_destroy_url
    assert_response :success
  end
end
