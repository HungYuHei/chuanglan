require 'test_helper'

class ChuanglanTest < Minitest::Test
  def setup
    ::Chuanglan.username = 'username'
    ::Chuanglan.password = 'password'
    @send_sms_gateway = 'https://sms.253.com/msg/send'
    @balance_gateway = 'https://sms.253.com/msg/balance'
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
    message_id = SecureRandom.hex
    stub_request(:post, @send_sms_gateway).
      to_return(status: 200, body: "20170302113947,0\n#{message_id}")

    assert_equal message_id, ::Chuanglan.send_to!('1234567890', 'hello')
  end

  def test_send_to_fail
    stub_request(:post, @send_sms_gateway).
      to_return(status: 200, body: "123456,101\nmessage_id")

    assert_raises(::Chuanglan::RequestException) { ::Chuanglan.send_to!('1234567890', 'hi') }
  end

  def test_balance_success
    balance = rand(1..100)
    stub_request(:post, @balance_gateway).
      to_return(status: 200, body: "20170302145922,0\n#{balance}")

    assert_equal balance, ::Chuanglan.balance
  end

  def test_balance_fail
    balance = rand(1..100)
    stub_request(:post, @balance_gateway).
      to_return(status: 200, body: "20170302145922,101")

    assert_raises(::Chuanglan::RequestException) { ::Chuanglan.balance }
  end
end
