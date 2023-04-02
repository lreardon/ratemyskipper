require "test_helper"

class SkippersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @skipper = skippers(:one)
  end

  test "should get index" do
    get skippers_url
    assert_response :success
  end

  test "should get new" do
    get new_skipper_url
    assert_response :success
  end

  test "should create skipper" do
    assert_difference("Skipper.count") do
      post skippers_url, params: { skipper: {  } }
    end

    assert_redirected_to skipper_url(Skipper.last)
  end

  test "should show skipper" do
    get skipper_url(@skipper)
    assert_response :success
  end

  test "should get edit" do
    get edit_skipper_url(@skipper)
    assert_response :success
  end

  test "should update skipper" do
    patch skipper_url(@skipper), params: { skipper: {  } }
    assert_redirected_to skipper_url(@skipper)
  end

  test "should destroy skipper" do
    assert_difference("Skipper.count", -1) do
      delete skipper_url(@skipper)
    end

    assert_redirected_to skippers_url
  end
end
