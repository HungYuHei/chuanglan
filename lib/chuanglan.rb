require 'chuanglan/version'
require 'chuanglan/request'
require 'chuanglan/request_exception'

module Chuanglan
  GATEWAY = 'http://222.73.117.158:80/msg/HttpBatchSendSM'
  @timeout = 5

  class << self
    attr_accessor :username, :password, :timeout

    def send_to!(recipients, message)
      Request.new(recipients, message).perform!
    end
  end
end
