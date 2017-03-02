require 'test_helper'

class ChuanglanInternetionalTest < Minitest::Test
  def setup
    ::Chuanglan::International.username = 'int_username'
    ::Chuanglan::International.password = 'int_password'
    @sms_gateway = 'https://intapi.253.com/mt'
  end

  def test_configuration
    refute_nil ::Chuanglan::International.username
    refute_nil ::Chuanglan::International.password
  end

  def test_send_to_success
    stub_request(:post, @sms_gateway).
      to_return(status: 200, body: "id=ID")

    assert ::Chuanglan::International.send_to!('1234567890', 'hello')
  end

  def test_send_to_fail
    stub_request(:post, @sms_gateway).
      to_return(status: 200, body: "r=101")

    assert_raises(::Chuanglan::RequestException) { ::Chuanglan::International.send_to!('861234567890', 'hi') }
  end
end
