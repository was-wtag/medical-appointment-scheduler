# frozen_string_literal: true

require 'test_helper'
require 'yaml'

class JwtServiceTest < ActiveSupport::TestCase
  def setup
    @users = YAML.load_file('test/payloads/users.yml', aliases: true)
    @payload = @users.fetch('valid_user', {})
  end

  test 'should encode payload' do
    token = JwtService.encode(@payload)
    assert_not_empty token
  end

  test 'should decode payload' do
    token = JwtService.encode(@payload)
    decoded_payload = JwtService.decode(token)
    assert_equal @payload, decoded_payload
  end
end
