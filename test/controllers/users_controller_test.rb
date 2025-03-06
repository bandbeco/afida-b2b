require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @user = users(:one)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    params = {
      user: {
        email: @user.email,
        first_name: @user.first_name,
        last_name: @user.last_name
      }
    }
    patch user_url(@user), params: params
    assert_redirected_to edit_user_url(@user)
  end
end
