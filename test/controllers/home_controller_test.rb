require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get home_index_url
    assert_response :success
  end

  test 'should get login' do
    get home_login_url
    assert_response :success
  end

  test 'should get signup and redirect to new user form' do
    get home_signup_url
    assert_redirected_to new_user_url
  end
end
