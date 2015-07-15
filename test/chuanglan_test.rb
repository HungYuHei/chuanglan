require 'test_helper'

class ChuanglanTest < Minitest::Test
  def setup
    ::Chuanglan.username = 'username'
    ::Chuanglan.password = 'password'
    @send_sms_gateway = 'http://222.73.117.158:80/msg/HttpBatchSendSM'
  end

  def test_configuration
    refute_nil ::Chuanglan.username
    refute_nil ::Chuanglan.password
    refute_nil ::Chuanglan.timeout
  end

  def test_that_it_has_a_version_number
    refute_nil ::Chuanglan::VERSION
  end

  def test_send_to_success
    stub_request(:post, @send_sms_gateway).
      to_return(status: 200, body: "123456,0\nmessage_id")

    assert ::Chuanglan.send_to!('1234567890', 'hello')
  end

  def test_send_to_fail
    stub_request(:post, @send_sms_gateway).
      to_return(status: 200, body: "123456,101\nmessage_id")

    assert_raises(::Chuanglan::RequestException) { ::Chuanglan.send_to!('1234567890', 'hi') }
  end

end
