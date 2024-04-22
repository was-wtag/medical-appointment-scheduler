# frozen_string_literal: true

require 'test_helper'
require 'yaml'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @users = YAML.load_file('test/payloads/users.yml', aliases: true)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should include new user form' do
    get new_user_url
    assert_select 'form[action=?]', users_path
  end

  test 'should create user with status set to pending' do
    assert_difference('User.count') do
      post users_url, params: { user: @users.fetch('valid_user', {}) }
    end

    assert User.last.pending?

    assert_redirected_to user_url(User.last)
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user), params: { user: {} }
    assert_redirected_to user_url(@user)
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
