# frozen_string_literal: true

require 'test_helper'
require 'yaml'

class UserTest < ActiveSupport::TestCase
  def setup
    @users = YAML.load_file('test/payloads/users.yml', aliases: true)
  end

  test 'should not save user without first_name' do
    user = User.new(@users.fetch('missing_first_name', {}))
    assert_not user.save
    assert user.errors.messages[:first_name].include?("can't be blank")
  end

  test 'should not save user without last_name' do
    user = User.new(@users.fetch('missing_last_name', {}))
    assert_not user.save
    assert user.errors.messages[:last_name].include?("can't be blank")
  end

  test 'should not save user without email' do
    user = User.new(@users.fetch('missing_email', {}))
    assert_not user.save
    assert user.errors.messages[:email].include?("can't be blank")
  end

  test 'should not save user without phone_number' do
    user = User.new(@users.fetch('missing_phone_number', {}))
    assert_not user.save
    assert user.errors.messages[:phone_number].include?("can't be blank")
  end

  test 'should not save user without password' do
    user = User.new(@users.fetch('missing_password', {}))
    assert_not user.save
    assert user.errors.messages[:password].include?("can't be blank")
  end

  test 'should not save user with invalid email format' do
    user = User.new(@users.fetch('invalid_email_format', {}))
    assert_not user.save
    assert user.errors.messages[:email].include?('is invalid')
  end

  test 'should not save user with invalid phone_number format' do
    user = User.new(@users.fetch('invalid_phone_number_format', {}))
    assert_not user.save
    assert user.errors.messages[:phone_number].include?('is invalid')
  end

  test 'should not save user with password less than 8 characters' do
    user = User.new(@users.fetch('invalid_password', {}))
    assert_not user.save
    assert user.errors.messages[:password].include?('is too short (minimum is 8 characters)')
  end

  test 'should not save with invalid password confirmation' do
    user = User.new(@users.fetch('invalid_password_confirmation', {}))
    assert_not user.save
    assert user.errors.messages[:password_confirmation].include?("doesn't match Password")
  end

  test 'should not save user with duplicate email' do
    user = User.new(@users.fetch('duplicate_email', {}))
    assert_not user.save
    assert user.errors.messages[:email].include?('has already been taken')
  end

  test 'should not save user with duplicate phone_number' do
    user = User.new(@users.fetch('duplicate_phone_number', {}))
    assert_not user.save
    assert user.errors.messages[:phone_number].include?('has already been taken')
  end

  test 'should save user with valid field values' do
    user = User.new(@users.fetch('valid_user', {}))
    assert user.save
    assert user.errors.messages.empty?
  end
end
