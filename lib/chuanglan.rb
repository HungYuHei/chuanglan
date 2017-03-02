require 'chuanglan/version'
require 'chuanglan/international'
require 'chuanglan/request'
require 'chuanglan/request_exception'

module Chuanglan
  GATEWAY = 'https://sms.253.com'
  @timeout = 5

  class << self
    attr_accessor :username, :password, :timeout

    def send_to!(recipients, message, params = {})
      params = base_params.merge(params)
      params[:phone] = Array(recipients).join(',')
      params[:msg] = message
      rsp = Request.new("#{GATEWAY}/msg/send", params).perform
      success_or_raise_exception(rsp)
    end

    private

    def base_params
      {
        un: username,
        pw: password,
        rd: 1,
      }
    end

    def success_or_raise_exception(response)
      headers, msgid= response.body.split("\n")
      timestamp, code = headers.split(',')
      code == '0' || raise(RequestException.new(code))
    end
  end
end
